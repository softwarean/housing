require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test 'presence validators' do
    account_number = Account.new
    refute account_number.valid?
    assert_equal([:apartment_id, :account_number], account_number.errors.keys)
  end
end
