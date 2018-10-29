require 'test_helper'

class Api::V1::SessionsControllerTest < ActionController::TestCase
  setup do
    @user = create :user

    include_content_type_header
  end

  test 'should create' do
    post :create, format: :json, params: { email: @user.email, password: @user.password }

    assert response_body.dig('data', 'auth_token').present?
    assert_response :success
  end

  test 'forbidden when wrong email' do
    post :create, format: :json, params: { email: 'wrong email', password: @user.password }

    assert_response :forbidden
  end

  test 'forbidden when wrong password' do
    post :create, format: :json, params: { email: @user.email, password: 'invalid password' }

    assert_response :forbidden
  end

  test 'not acceptable content type returns 406' do
    @request.headers['Content-Type'] = Mime[:xml].to_s
    post :create, format: :json, params: { email: @user.email, password: @user.password }

    assert_response :not_acceptable
  end
end
