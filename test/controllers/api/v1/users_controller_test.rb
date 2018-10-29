require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase
  setup do
    @user_attrs = attributes_for :user

    include_content_type_header
  end

  test 'should register a new user' do
    assert_difference('User.count', 1) do
      post :create, params: { user: @user_attrs }
    end

    assert_response :success
  end

  test 'should not register if data is invalid' do
    @user_attrs[:email] = 'invalid email'

    assert_no_difference('User.count') do
      post :create, params: { user: @user_attrs }
    end

    assert response_body.dig('errors', 'email')&.any?
    assert_response :unprocessable_entity
  end
end
