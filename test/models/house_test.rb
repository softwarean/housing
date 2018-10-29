require 'test_helper'

class HouseTest < ActiveSupport::TestCase
  test 'presence validators' do
    house = House.new
    refute house.valid?
    assert_equal([:street_id, :house_number], house.errors.keys)
  end

  test 'should not save duplicate' do
    house = create :house

    duplicate = house.dup

    assert_no_difference('House.count') do
      duplicate.save
    end

    assert_equal([:street_id], duplicate.errors.keys)
  end

  test 'should not destroy if any apartments' do
    apartment = create :apartment
    house = create :house, apartments: [apartment]

    assert_no_difference('House.count') do
      house.destroy
    end

    assert_equal([:apartments], house.errors.keys)
  end

  test 'should destroy with common house meter' do
    meter = create :meter
    house = create :house, meters: [meter]

    assert_difference('House.count', -1) do
      house.destroy
    end
  end
end
