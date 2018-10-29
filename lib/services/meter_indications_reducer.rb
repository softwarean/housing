module Services::MeterIndicationsReducer
  BATCH_SIZE = 1000

  class << self
    def process
      Meter.find_each do |meter|
        last_reduced_indication = meter.reduced_indications.order(:created_at).select(:created_at).last
        indications_query = meter.meter_indications
        indications_query = indications_query.where('created_at > ?', last_reduced_indication.created_at) if last_reduced_indication.present?

        reduced_indication = nil
        total_records = indications_query.count
        (0..total_records).step(BATCH_SIZE) do |offset|
          indications_query.order(:transmitted_at).offset(offset).limit(BATCH_SIZE).each do |indication|
            next if indication.data.nil?

            reduced_indication = current_or_load(reduced_indication, meter, indication)

            if meter.kind == 'electricity_meter'
              reduced_indication.last_total = indication.data[MeterIndication::ELECTRICITY_TOTAL_KEY]
              reduced_indication.last_daily = indication.data[MeterIndication::ELECTRICITY_DAILY_KEY]
              reduced_indication.last_nightly = indication.data[MeterIndication::ELECTRICITY_NIGTLY_KEY]
            else
              next if !indication.data['quality']
              reduced_indication.last_total = indication.data[MeterIndication::WATER_KEY]
            end

            save_reduced_indication(meter, indication, reduced_indication) if reduced_indication.changed?
          end
        end
      end
    end

    private

    def current_or_load(reduced_indication, meter, indication)
      transfer_date_time = indication.transmitted_at
      transfer_date = transfer_date_time.to_date
      transfer_hour = transfer_date_time.hour

      unless reduced_indication_loaded?(reduced_indication, meter, transfer_date, transfer_hour)
        return ReducedIndication
          .find_or_initialize_by(meter: meter, date: transfer_date, hour: transfer_hour)
      end

      reduced_indication
    end

    def reduced_indication_loaded?(reduced_indication, meter, transfer_date, transfer_hour)
      reduced_indication.present? && reduced_indication.meter_id == meter.id &&
        reduced_indication.date == transfer_date && reduced_indication.hour == transfer_hour
    end

    def save_reduced_indication(meter, indication, reduced_indication)
      unless reduced_indication.save
        error_message = build_error_message(meter, indication, reduced_indication)
        Airbrake.notify(Exception.new(error_message))
      end
    end

    def build_error_message(meter, indication, reduced_indication)
      %{
        Error while saving reduced_indication for meter with id #{meter.id} built from indication with id #{indication.id}.
        Errors: #{reduced_indication.errors.full_messages.join(', ')}
      }
    end
  end
end
