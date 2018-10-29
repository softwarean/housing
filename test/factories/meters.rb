FactoryGirl.define do
  factory :meter do
    uuid { generate :string }
    kind 'cold_water_meter'
    account_number

    trait :cold_water_meter do
      kind 'cold_water_meter'
    end

    trait :hot_water_meter do
      kind 'hot_water_meter'
    end

    trait :electricity_meter do
      kind 'electricity_meter'
    end
  end
end
