module MeterIndicationRepository
  extend ActiveSupport::Concern

  included do
    scope :web, -> { order(created_at: :desc) }
    scope :for_meter, ->(meter_uuid) { where(meter_uuid: meter_uuid) }
    scope :transmitted_between, ->(datetime_range) { where(transmitted_at: datetime_range) }
    scope :data_field, ->(field_name) { pluck("CAST(data ->> '#{field_name}' AS float)") }
  end
end
