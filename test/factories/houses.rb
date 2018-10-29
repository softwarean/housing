FactoryGirl.define do
  factory :house do
    street
    house_number { generate(:string) }
  end
end
