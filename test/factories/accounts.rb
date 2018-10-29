FactoryGirl.define do
  factory :account do
    apartment
    account_number

    factory :account_with_users do
      transient do
        users []
      end

      after(:create) do |account, evaluator|
        account.users = evaluator.users
        account.save!
      end
    end
  end
end
