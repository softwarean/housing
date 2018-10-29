class ReducedIndication < ApplicationRecord
  include ReducedIndicationRepository

  belongs_to :meter

  validates :date, :hour, :last_total, presence: true
  validates :hour, inclusion: { in: (0..23) }
  validates :last_total, :last_daily, :last_nightly, numericality: { only_integer: true }, allow_nil: true
end
