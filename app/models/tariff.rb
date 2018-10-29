class Tariff < ApplicationRecord
  extend Enumerize

  validates :name, :unit_of_measure, :value, presence: true
  validates :value, currency: true
  validates_numericality_of :value, greater_than_or_equal_to: 0

  enumerize :kind, in: [:cold_water, :hot_water, :electricity_daily, :electricity_nightly]
end
