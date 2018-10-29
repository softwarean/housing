class Service < ApplicationRecord
  validates :name, :cost, presence: true
  validates :cost, currency: true
  validates_numericality_of :cost, greater_than_or_equal_to: 0
end
