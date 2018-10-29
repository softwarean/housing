require 'test_helper'

class Api::V1::Manager::ServicesControllerTest < ActionController::TestCase
  include IndexPaginationTest
  include DefaultCrudTokenNecessityTest
  include DefaultCrudManagerAuthorizationTest

  setup do
    manager = create :user, :manager
    token = auth_token(manager)

    @service = create :service
    @service_attrs = attributes_for :service

    include_content_type_header
    include_auth_header(token)
  end

  test 'should get index' do
    get :index, params: { page: 1, per_page: 25 }
    assert_response :success

    assert response_body.dig('data', 'services')&.any?
  end

  test 'should create service' do
    assert_difference('Service.count', 1) do
      post :create, params: { service: @service_attrs }
    end

    assert response_body.dig('data', 'id').present?
    assert_response :success
  end

  test 'should not create service with invalid data' do
    @service_attrs[:cost] = 10.879
    post :create, params: { service: @service_attrs }

    assert response_body.dig('errors', 'cost')&.any?
    assert_response :unprocessable_entity
  end

  test 'should update service' do
    new_cost = @service.cost + 10.0
    put :update, params: { id: @service.id, service: { cost: new_cost } }

    assert_equal @service.reload.cost, new_cost
    assert_response :success
  end

  test 'should not update service with invalid data' do
    old_cost = @service.cost

    put :update, params: { id: @service.id, service: { cost: -100.0 } }

    assert_equal @service.reload.cost, old_cost
    assert response_body.dig('errors', 'cost')&.any?
    assert_response :unprocessable_entity
  end

  test 'should destroy service' do
    assert_difference('Service.count', -1) do
      delete :destroy, params: { id: @service.id }
    end

    assert_response :success
  end
end
