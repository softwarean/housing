require 'test_helper'

class TariffTest < ActiveSupport::TestCase
  test 'presence validators' do
    tariff = Tariff.new
    refute tariff.valid?
    assert_equal([:name, :unit_of_measure, :value], tariff.errors.keys)
  end
end
