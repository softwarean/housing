FactoryGirl.define do
  factory :reduced_indication do
    meter
    date
    hour { rand(0..23) }
    last_total { generate :integer }
  end
end
