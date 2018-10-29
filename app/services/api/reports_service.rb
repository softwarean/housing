module Api::ReportsService
  class << self
    def diffs_by_meters_kind(meters, period)
      grouped_meters = meters.group_by(&:kind)

      grouped_meters.each_with_object({}) do |(meters_kind, meters_by_kind), acc|
        acc[meters_kind] = Api::IndicationsDiffsService.diffs(meters_by_kind, period)
      end
    end

    def diffs_with_tariffs(meters, period)
      diffs_by_kind = diffs_by_meters_kind(meters, period)

      Api::DiffsTransformationService.build_response(diffs_by_kind, tariffs)
    end

    private

    def tariffs
      Tariff.where(kind: [:cold_water, :hot_water, :electricity_daily, :electricity_nightly])
    end
  end
end
