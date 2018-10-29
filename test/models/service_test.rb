require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  test 'presence validators' do
    service = Service.new
    refute service.valid?
    assert_equal([:name, :cost], service.errors.keys)
  end
end
