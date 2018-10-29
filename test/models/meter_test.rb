require 'test_helper'

class MeterTest < ActiveSupport::TestCase
  test 'validators' do
    meter = Meter.new
    refute meter.valid?
    assert_equal([:uuid, :kind], meter.errors.keys)
  end
end
