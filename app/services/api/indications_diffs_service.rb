module Api::IndicationsDiffsService
  class << self
    def diffs(meters, period)
      data_by_meters = []

      if yearly_data_required?(period)
        meters.each { |meter| data_by_meters.push(data_by_months(meter, period)) }

        return Api::DiffsTransformationService.aggregate_data_for_year!(data_by_meters, meters.first.kind)
      elsif daily_data_required?(period)
        meters.each { |meter| data_by_meters.push(data_by_hours(meter, period)) }

        return Api::DiffsTransformationService.aggregate_data_for_day!(data_by_meters, meters.first.kind)
      else
        meters.each { |meter| data_by_meters.push(data_by_days(meter, period)) }

        return Api::DiffsTransformationService.aggregate_data_for_month!(data_by_meters, meters.first.kind)
      end
    end

    private

    def yearly_data_required?(period)
      period.first.month != period.last.month
    end

    def daily_data_required?(period)
      period.first.to_date == period.last.to_date
    end

    def data_by_months(meter, period)
      indications = ReducedIndication.for_meter(meter).last_for_each_date_in_period(period).to_a
      last_previous_indication = load_last_previous_indication(meter, period.first, period)

      last_for_each_month = []
      last_for_each_month.push(last_previous_indication) if last_previous_indication.present?

      grouped_by_month = indications.group_by { |indication| indication.date.month }
      grouped_by_month.each do |_, group|
        max_by_date = group.sort_by(&:date).last
        last_for_each_month.push(max_by_date)
      end

      sorted_indications = last_for_each_month.sort_by { |indication| indication.date }

      Api::DiffsTransformationService.build_diffs_data(meter, sorted_indications) { |indication| indication.date.month }
    end

    def data_by_hours(meter, today_range)
      today = today_range.first

      indications = ReducedIndication.for_meter(meter).where(date: today).order(:hour).to_a
      last_previous_indication = load_last_previous_indication(meter, today, today)

      indications.unshift(last_previous_indication) if last_previous_indication.present?

      Api::DiffsTransformationService.build_diffs_data(meter, indications) do |indication|
        DateTime.new(today.year, today.month, today.day, indication.hour).strftime('%H:%M')
      end
    end

    def data_by_days(meter, period)
      indications = ReducedIndication.for_meter(meter).last_for_each_date_in_period(period).to_a
      last_previous_indication = load_last_previous_indication(meter, period.first, period)

      indications.unshift(last_previous_indication) if last_previous_indication.present?

      Api::DiffsTransformationService.build_diffs_data(meter, indications) { |indication| indication.date.day }
    end

    def load_last_previous_indication(meter, before, period)
      last_previous_indication = ReducedIndication.for_meter(meter).before(before).by_transmission.last

      if last_previous_indication.nil?
        last_previous_indication = ReducedIndication.for_meter(meter).where(date: period).by_transmission.first
      end

      last_previous_indication
    end
  end
end
