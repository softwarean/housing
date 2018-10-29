require 'test_helper'

class MeterIndicationTest < ActiveSupport::TestCase
  test 'presence validators' do
    meter_indication = MeterIndication.new
    refute meter_indication.valid?
    assert_equal([:meter_uuid, :meter_description, :transmitted_at], meter_indication.errors.keys)
  end

  test 'deserialization' do
    meter_indication = create :meter_indication

    snake_case_json = meter_indication.to_json
    camel_case_json = {
      meterUUID: meter_indication.meter_uuid,
      meterDescription: meter_indication.meter_description,
      transmittedAt: meter_indication.transmitted_at,
      data: meter_indication.data,
      extra_attribute: 'extra attribute to test deserialization not fails'
    }.to_json

    test_meter_indication = MeterIndication.new
    test_meter_indication.from_json(snake_case_json)

    assert_equal(meter_indication.attributes.except('id', 'created_at', 'updated_at'),
      test_meter_indication.attributes.except('id', 'created_at', 'updated_at'))

    test_meter_indication = MeterIndication.new
    test_meter_indication.from_json(camel_case_json)

    assert_equal(meter_indication.attributes.except('id', 'created_at', 'updated_at'),
      test_meter_indication.attributes.except('id', 'created_at', 'updated_at'))
  end
end
