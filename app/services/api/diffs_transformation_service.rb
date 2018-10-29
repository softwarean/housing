module Api::DiffsTransformationService
  class << self
    def build_diffs_data(meter, indications)
      diffs_data = []

      i = 0
      while i < indications.length - 1
        indication = indications[i]
        next_indication = indications[i + 1]

        diff = {
          date: next_indication.date,
          hour: next_indication.hour,
          total: next_indication.last_total - indication.last_total
        }

        if meter.kind == 'electricity_meter'
          diff[:daily] = next_indication.last_daily - indication.last_daily
          diff[:nightly] = next_indication.last_nightly - indication.last_nightly
        end

        diffs_data << diff

        i += 1
      end

      diffs_data
    end

    def aggregate_data_for_year!(meters_group_data, meter_kind)
      aggregated = aggregate_data!(meters_group_data, meter_kind) { |record, data| record[:date].month == data[:date].month }

      sorted = aggregated.sort_by { |d| d[:date] }
      build_period!(sorted) { |data| I18n.l(data[:date], format: :month) }
    end

    def aggregate_data_for_day!(meters_group_data, meter_kind)
      aggregated = aggregate_data!(meters_group_data, meter_kind) { |record, data| record[:hour] == data[:hour] }

      sorted = aggregated.sort_by { |d| d[:hour] }
      build_period!(sorted) { |data| DateTime.now.change(hour: data[:hour]).strftime('%H:%M') }
    end

    def aggregate_data_for_month!(meters_group_data, meter_kind)
      aggregated = aggregate_data!(meters_group_data, meter_kind) { |record, data| record[:date] == data[:date] }

      sorted = aggregated.sort_by { |d| d[:date] }
      build_period!(sorted) { |data| I18n.l(data[:date], format: '%d %B') }
    end

    def build_response(grouped_diffs, tariffs)
      diffs_with_tariffs = []

      grouped_diffs.each do |kind, diffs_array|
        diffs_with_tariff = (kind == 'electricity_meter') ? electricity_data(tariffs) : water_data(kind, tariffs)

        diffs_with_tariff[:type] = kind
        diffs_with_tariff[:data] = diffs_array

        diffs_with_tariffs.push(diffs_with_tariff)
      end

      diffs_with_tariffs
    end

    private

    def aggregate_data!(meters_group_data, meter_kind)
      accumulator = meters_group_data.shift

      while meters_group_data.length > 0
        next_meter_data = meters_group_data.shift
        next_meter_data.each do |data|
          match_in_accumulator = accumulator.find { |record| yield(record, data) }

          if match_in_accumulator.present?
            update_match!(match_in_accumulator, data, meter_kind)
          else
            accumulator << data
          end
        end
      end

      accumulator
    end

    def update_match!(match, data, meter_kind)
      match[:total] += data[:total]

      if meter_kind == 'electricity_meter'
        match[:daily] += data[:daily]
        match[:nightly] += data[:nightly]
      end
    end

    def build_period!(aggregated_data)
      aggregated_data.map do |data|
        data[:period] = yield(data)
        data.except(:date, :hour)
      end
    end

    def electricity_data(tariffs)
      daily_tariff = find_tariff('electricity_daily', tariffs)
      nightly_tariff = find_tariff('electricity_nightly', tariffs)

      {
        daily_tariff: tariff_for_response(daily_tariff),
        nightly_tariff: tariff_for_response(nightly_tariff)
      }
    end

    def water_data(meters_kind, tariffs)
      tariff_kind = (meters_kind == 'cold_water_meter') ? 'cold_water' : 'hot_water'
      tariff = find_tariff(tariff_kind, tariffs)

      {
        tariff: tariff_for_response(tariff)
      }
    end

    def find_tariff(tariff_kind, tariffs)
      tariffs.find { |t| t.kind == tariff_kind }
    end

    def tariff_for_response(tariff)
      {
        unit_of_measure: tariff.unit_of_measure,
        value: tariff.value
      }
    end
  end
end
