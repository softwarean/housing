require 'test_helper'

class StreetTest < ActiveSupport::TestCase
  test 'presence validators' do
    street = Street.new
    refute street.valid?
    assert_equal([:name], street.errors.keys)
  end

  test 'should not destroy if houses present' do
    street = create :street
    create :house, street: street

    assert_no_difference('Street.count') do
      street.destroy
    end

    assert_equal([:houses], street.errors.keys)
  end
end
