require 'test_helper'

class Api::V1::User::AccountsControllerTest < ActionController::TestCase
  include DefaultCrudTokenNecessityTest

  setup do
    @user = create :user_with_accounts, accounts_count: 1
    @token = auth_token(@user)

    account = @user.accounts.first
    @user_with_same_account = create :user, accounts: [account]

    include_content_type_header
    include_auth_header(@token)
  end

  test 'should get current user account info' do
    get :show
    assert_response :success

    assert response_body.dig('data', 'account', 'users')&.any?

    [@user, @user_with_same_account].each do |user|
      match = response_body['data']['account']['users'].find do |record|
        record['name'] == user.name && record['phone'] == user.phone
      end

      assert match.present?
    end
  end
end
