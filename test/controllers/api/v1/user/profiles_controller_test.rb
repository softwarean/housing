require 'test_helper'

class Api::V1::User::ProfilesControllerTest < ActionController::TestCase
  include DefaultCrudTokenNecessityTest

  setup do
    @user = create :user_with_accounts
    @token = auth_token(@user)

    include_content_type_header
    include_auth_header(@token)
  end

  test 'should get current user profile' do
    get :show
    assert_response :success

    assert response_body.dig('data', 'profile').present?
    assert_equal response_body['data']['profile']['name'], @user.name
    assert_equal response_body['data']['profile']['email'], @user.email
  end

  test 'should get current user profile if no accounts' do
    user_without_accounts = create :user
    token = auth_token(user_without_accounts)

    include_auth_header(token)

    get :show
    assert_response :success

    assert response_body.dig('data', 'profile').present?
    assert_equal response_body['data']['profile']['name'], user_without_accounts.name
    assert_equal response_body['data']['profile']['email'], user_without_accounts.email
    assert_nil response_body['data']['profile']['address']
    assert_nil response_body['data']['profile']['account_number']
  end

  test 'should update current user profile' do
    new_email = 'new_email@examle.com'
    put :update, params: { user: { email: new_email } }

    @user.reload

    assert_equal @user.email, new_email
    assert_response :success
  end

  test 'should not update with invalid data' do
    old_email = @user.email

    put :update, params: { user: { email: 'invalid email' } }

    @user.reload

    assert_equal @user.email, old_email
    assert response_body.dig('errors', 'email')&.any?
    assert_response :unprocessable_entity
  end

  test 'should require password confirmation on update' do
    put :update, params: { user: { password: 'secure_password' } }

    assert response_body.dig('errors', 'password_confirmation')&.any?
    assert_response :unprocessable_entity
  end

  test 'should not update if password does not match confirmation' do
    put :update, params: { user: { password: 'secure_password', password_confirmation: 'not_secure_password' } }

    assert response_body.dig('errors', 'password_confirmation')&.any?
    assert_response :unprocessable_entity
  end
end
