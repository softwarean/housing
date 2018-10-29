FactoryGirl.define do
  factory :claim do
    applicant factory: :user
    service
    deadline

    trait :in_processing do
      aasm_state 'in_processing'
    end

    trait :rejected do
      aasm_state 'rejected'
    end

    trait :completed do
      aasm_state 'completed'
    end
  end
end
