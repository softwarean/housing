require 'test_helper'

class ReducedIndicationTest < ActiveSupport::TestCase
  test 'presence validators' do
    model = ReducedIndication.new
    refute model.valid?
    assert_equal([:date, :hour, :last_total], model.errors.keys)
  end
end
