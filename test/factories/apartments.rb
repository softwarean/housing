FactoryGirl.define do
  factory :apartment do
    house
    number { generate(:integer) }
  end
end
