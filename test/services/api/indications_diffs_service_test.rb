require 'test_helper'

class Api::IndicationsDiffsServiceTest < ActiveSupport::TestCase
  setup do
    @meter1 = create :meter
    @meter2 = create :meter

    @today = DateTime.current
    @day_range = @today.beginning_of_day..@today.end_of_day
    @month_range = @today.beginning_of_month..@today.end_of_month
    @year_range = @today.beginning_of_year..@today.end_of_year
  end

  test 'yearly indications data' do
    reduced_indications = []

    3.times do |i|
      month = i + 1

      [@meter1, @meter2].each do |meter|
        reduced_indication = create :reduced_indication, meter: meter,
          date: Date.new(@today.year, month), last_total: i

        reduced_indications << reduced_indication
      end
    end

    diffs_set = Api::IndicationsDiffsService.diffs([@meter1, @meter2], @year_range)

    assert_equal(diffs_set.length, reduced_indications.length / 2)
    assert(diffs_set.map { |d| d[:period] } - reduced_indications.map { |i| I18n.l(i.date, format: :month) }.uniq).blank?
    assert(diffs_set.map { |d| d[:total] } - [0, 2, 2]).blank?

    diffs_set.each do |d|
      assert_nil d[:daily]
      assert_nil d[:nightly]
    end
  end

  test 'daily indications data' do
    reduced_indications = []

    3.times do |i|
      [@meter1, @meter2].each do |meter|
        reduced_indication = create :reduced_indication, meter: meter,
          hour: i, last_total: i

        reduced_indications << reduced_indication
      end
    end

    diffs_set = Api::IndicationsDiffsService.diffs([@meter1, @meter2], @day_range)

    assert_equal(diffs_set.length, reduced_indications.length / 2)
    assert(diffs_set.map { |d| d[:period] } - reduced_indications.map { |i| DateTime.now.change(hour: i[:hour]).strftime('%H:%M') }.uniq).blank?
    assert(diffs_set.map { |d| d[:total] } - [0, 2, 2]).blank?

    diffs_set.each do |d|
      assert_nil d[:daily]
      assert_nil d[:nightly]
    end
  end

  test 'monthly indications data' do
    reduced_indications = []

    3.times do |i|
      day = i + 1

      [@meter1, @meter2].each do |meter|
        reduced_indication = create :reduced_indication, meter: meter,
        date: Date.new(@today.year, @today.month, day), last_total: i

        reduced_indications << reduced_indication
      end
    end

    diffs_set = Api::IndicationsDiffsService.diffs([@meter1, @meter2], @month_range)

    assert_equal(diffs_set.length, reduced_indications.length / 2)
    assert(diffs_set.map { |d| d[:period] } - reduced_indications.map { |i| I18n.l(i.date, format: '%d %B') }.uniq).blank?
    assert(diffs_set.map { |d| d[:total] } - [0, 2, 2]).blank?

    diffs_set.each do |d|
      assert_nil d[:daily]
      assert_nil d[:nightly]
    end
  end
end
