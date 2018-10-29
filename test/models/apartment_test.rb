require 'test_helper'

class ApartmentTest < ActiveSupport::TestCase
  test 'presence validators' do
    apartment = Apartment.new
    refute apartment.valid?
    assert_equal([:house_id, :number], apartment.errors.keys)
  end

  test 'should not save duplicate' do
    apartment = create :apartment

    duplicate = apartment.dup

    assert_no_difference('Apartment.count') do
      duplicate.save
    end

    assert_equal([:house_id], duplicate.errors.keys)
  end

  test 'should not destroy if account present' do
    account = create :account
    apartment = create :apartment, account: account

    assert_no_difference('Apartment.count') do
      apartment.destroy
    end

    assert_equal([:account], apartment.errors.keys)
  end
end
