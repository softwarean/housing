FactoryGirl.define do
  factory :user do
    name
    phone '+79998887777'
    email
    password '123456'
    password_confirmation '123456'
    role 'user'

    trait :admin do
      role 'admin'
    end

    trait :manager do
      role 'manager'
    end

    factory :user_with_accounts do
      transient do
        accounts_count 5
      end

      after(:create) do |user, evaluator|
        accounts = create_list(:account, evaluator.accounts_count)
        user.accounts = accounts
        user.save!
      end
    end
  end
end
