FactoryGirl.define do
  factory :tariff do
    name
    unit_of_measure 'Вт*ч'
    value 10.0
  end

  trait :cold_water do
    kind 'cold_water'
  end

  trait :hot_water do
    kind 'hot_water'
  end

  trait :electricity_daily do
    kind 'electricity_daily'
  end

  trait :electricity_nightly do
    kind 'electricity_nightly'
  end
end
