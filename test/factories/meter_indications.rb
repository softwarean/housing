FactoryGirl.define do
  factory :meter_indication do
    meter_uuid { generate :string }
    meter_description { generate :string }
    transmitted_at
    data { generate :water_meter_data }
  end

  trait :electricity_indication do
    data { generate :electricity_meter_data }
  end
end
