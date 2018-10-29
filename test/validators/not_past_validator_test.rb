require 'test_helper'

class NotPastValidatable
  include ActiveModel::Validations
  attr_accessor :date

  validates :date, not_past: true
end

class NotPastValidatorTest < ActiveSupport::TestCase
  setup do
    @validatable = NotPastValidatable.new
  end

  test 'should invalidate date' do
    invalid_date = DateTime.current - 1.month

    @validatable.date = invalid_date
    refute @validatable.valid?
  end

  test 'should validate date' do
    valid_date = DateTime.current + 1.month

    @validatable.date = valid_date
    assert @validatable.valid?
  end
end
