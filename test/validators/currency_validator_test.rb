require 'test_helper'

class CurrencyValidatable
  include ActiveModel::Validations
  attr_accessor :cost

  validates :cost, currency: true
end

class CurrencyValidatorTest < ActiveSupport::TestCase
  setup do
    @validatable = CurrencyValidatable.new
    @valid_costs = [10, 10.1, 15.25]
  end

  test 'should invalidate cost' do
    invalid_cost = 10.123
    @validatable.cost = invalid_cost
    refute @validatable.valid?
  end

  test 'should validate cost' do
    @valid_costs.each do |cost|
      @validatable.cost = cost
      assert @validatable.valid?
    end
  end
end
