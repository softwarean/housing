class Meter < ApplicationRecord
  extend Enumerize
  include MeterRepository

  has_many :meter_indications, primary_key: :uuid, foreign_key: :meter_uuid
  has_many :reduced_indications, dependent: :destroy

  belongs_to :account, primary_key: :account_number, foreign_key: :account_number

  validates :uuid, :kind, presence: true
  validates :uuid, uniqueness: true

  enumerize :kind, in: [:cold_water_meter, :hot_water_meter, :electricity_meter]

  ransack_alias :street, :account_apartment_house_street_id
  ransack_alias :house, :account_apartment_house_id
  ransack_alias :apartment, :account_apartment_id
end
