require 'test_helper'

class ClaimTest < ActiveSupport::TestCase
  test 'presence validators' do
    claim = Claim.new
    refute claim.valid?
    assert_equal([:user_id, :service_id, :deadline], claim.errors.keys)
  end
end
