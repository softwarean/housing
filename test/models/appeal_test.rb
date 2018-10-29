require 'test_helper'

class AppealTest < ActiveSupport::TestCase
  test 'presence validators' do
    appeal = Appeal.new
    refute appeal.valid?
    assert_equal([:user_id, :content], appeal.errors.keys)
  end
end
