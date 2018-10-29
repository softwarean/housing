module ReducedIndicationRepository
  extend ActiveSupport::Concern

  included do
    scope :for_meter, ->(meter) { where(meter: meter) }
    scope :before, ->(date) { where('date < ?', date) }
    scope :by_transmission, -> { order(:date, :hour) }
    scope :last_for_each_date_in_period, ->(period) { where(date: period).select('DISTINCT ON (date) *').order(:date, hour: :desc) }
  end
end
