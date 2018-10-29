require 'test_helper'

class Api::V1::User::ServicesControllerTest < ActionController::TestCase
  include DefaultCrudTokenNecessityTest

  setup do
    user = create :user
    token = auth_token(user)

    create :service

    include_content_type_header
    include_auth_header(token)
  end

  test 'should get services list' do
    get :index, params: { page: 1, per_page: 25 }
    assert_response :success

    assert response_body.dig('data', 'services')&.any?
  end

  test 'should return unprocessable entity if page param is missing' do
    get :index, params: { per_page: 25 }

    assert_response :unprocessable_entity
  end

  test 'should return unprocessable entity if per_page param is missing' do
    get :index, params: { page: 1 }

    assert_response :unprocessable_entity
  end
end
