FactoryGirl.define do
  factory :appeal do
    user
    content

    trait :completed do
      aasm_state 'completed'
    end
  end
end
