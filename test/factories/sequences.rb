FactoryGirl.define do
  sequence :string, aliases: [:name, :account_number, :content] do |n|
    "string-#{n}"
  end

  sequence :email do |n|
    "example-#{n}@restream.rt.ru"
  end

  sequence :integer do |n|
    n
  end

  sequence :float do |n|
    n.to_f + 0.5
  end

  sequence :date, aliases: [:transmitted_at] do |n|
    DateTime.current.beginning_of_day + n.minutes
  end

  sequence :deadline do |n|
    DateTime.current + n.days
  end

  sequence :water_meter_data do |n|
    { MeterIndication::WATER_KEY => n, quality: true }
  end

  sequence :electricity_meter_data do |n|
    total = n * 10
    daily = total / 2
    nightly = daily

    {
      MeterIndication::ELECTRICITY_TOTAL_KEY => total,
      MeterIndication::ELECTRICITY_DAILY_KEY => daily,
      MeterIndication::ELECTRICITY_NIGTLY_KEY => nightly
    }
  end
end
