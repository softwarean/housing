require 'test_helper'

class MeterIndicationsReducingJobTest < ActiveSupport::TestCase
  setup do
    @cold_water_meter = create :meter
    @electricity_meter = create :meter, :electricity_meter

    @water_indications = []
    @el_total_indications = []
    @el_daily_indications = []
    @el_nightly_indications = []
  end

  test 'idications reducing job' do
    generate_indications

    assert_difference('ReducedIndication.count', 2) do
      MeterIndicationsReducingJob.perform
    end

    reduced_water_indications = ReducedIndication.for_meter(@cold_water_meter)
    reduced_electricity_indications = ReducedIndication.for_meter(@electricity_meter)

    assert_equal reduced_water_indications.count, 1
    assert_equal reduced_electricity_indications.count, 1

    assert_equal reduced_water_indications.first.last_total, @water_indications.last
    assert_equal reduced_electricity_indications.first.last_total, @el_total_indications.last
    assert_equal reduced_electricity_indications.first.last_daily, @el_daily_indications.last
    assert_equal reduced_electricity_indications.first.last_nightly, @el_nightly_indications.last
  end

  test 'indications reducing job without indications does not fall' do
    assert_no_difference('ReducedIndication.count') do
      MeterIndicationsReducingJob.perform
    end
  end

  test 'correct ordering by transmitted at in job' do
    midday = DateTime.current.midday

    last_by_transmitted = create :meter_indication, meter_uuid: @cold_water_meter.uuid,
      transmitted_at: midday - 1.minute
    create :meter_indication, meter_uuid: @cold_water_meter.uuid,
      transmitted_at: midday - 10.minutes
    create :meter_indication, meter_uuid: @cold_water_meter.uuid,
      transmitted_at: midday - 5.minutes

    assert_difference('ReducedIndication.count', 1) do
      MeterIndicationsReducingJob.perform
    end

    assert_equal ReducedIndication.first.last_total, last_by_transmitted.data[MeterIndication::WATER_KEY]
  end

  test 'indications reducing job with indications containing nil data field does not fall' do
    create :meter_indication, meter_uuid: @cold_water_meter.uuid, data: nil
    create :meter_indication, meter_uuid: @cold_water_meter.uuid

    assert_difference('ReducedIndication.count', 1) do
      assert_nothing_raised { MeterIndicationsReducingJob.perform }
    end
  end

  test 'indications reducing job with indications containing nil indications data does not fall' do
    create :meter_indication, meter_uuid: @cold_water_meter.uuid, data: { MeterIndication::WATER_KEY => nil }

    assert_nothing_raised { MeterIndicationsReducingJob.perform }
  end

  test 'indications reducing job with indications containing not numerical indication field does not fall' do
    create :meter_indication, meter_uuid: @cold_water_meter.uuid, data: { MeterIndication::WATER_KEY => 'test' }

    assert_nothing_raised { MeterIndicationsReducingJob.perform }
  end

  test 'should ignore water meter bad indications' do
    beginning_of_hour = DateTime.current.beginning_of_hour

    indication = create :meter_indication, meter_uuid: @cold_water_meter.uuid, transmitted_at: beginning_of_hour

    bad_indication = build :meter_indication, meter_uuid: @cold_water_meter.uuid, transmitted_at: beginning_of_hour + 10.minutes
    bad_indication.data[:quality] = false
    bad_indication.data[MeterIndication::WATER_KEY] = -100
    bad_indication.save!

    assert_difference('ReducedIndication.count', 1) do
      MeterIndicationsReducingJob.perform
    end

    reduced_water_indications = ReducedIndication.for_meter(@cold_water_meter)

    assert_equal reduced_water_indications.count, 1
    assert_equal reduced_water_indications.first.last_total, indication.data[MeterIndication::WATER_KEY]
  end

  private

  def generate_indications
    now = DateTime.current

    3.times do |i|
      minute = i + 10
      transmitted_at = DateTime.new(now.year, now.month, now.day, now.hour, minute)

      water = create :meter_indication, meter_uuid: @cold_water_meter.uuid, transmitted_at: transmitted_at
      el = create :meter_indication, :electricity_indication, meter_uuid: @electricity_meter.uuid,
        transmitted_at: transmitted_at

      @water_indications << water.data[MeterIndication::WATER_KEY]
      @el_total_indications << el.data[MeterIndication::ELECTRICITY_TOTAL_KEY]
      @el_daily_indications << el.data[MeterIndication::ELECTRICITY_DAILY_KEY]
      @el_nightly_indications << el.data[MeterIndication::ELECTRICITY_NIGTLY_KEY]
    end
  end
end
