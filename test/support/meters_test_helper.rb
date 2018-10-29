module MetersTestHelper
  def generate_indications(meter)
    if meter.kind == 'electricity_meter'
      create_list :meter_indication, 2, :electricity_indication, meter_uuid: meter.uuid
    else
      create_list :meter_indication, 2, meter_uuid: meter.uuid
    end
  end
end
