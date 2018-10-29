module ApartmentRepository
  extend ActiveSupport::Concern

  included do
    scope :order_by_address, -> { order('streets.name', 'houses.house_number', :number) }
  end
end
