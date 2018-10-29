class MeterIndication < ApplicationRecord
  WATER_KEY = 'value'.freeze
  ELECTRICITY_TOTAL_KEY = 'A+0'.freeze
  ELECTRICITY_DAILY_KEY = 'A+1'.freeze
  ELECTRICITY_NIGTLY_KEY = 'A+2'.freeze

  include Models::JsonSerializations
  include MeterIndicationRepository

  validates :meter_uuid, :meter_description, :transmitted_at, presence: true
end
