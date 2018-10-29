require 'test_helper'

class Api::V1::Manager::TariffsControllerTest < ActionController::TestCase
  include IndexPaginationTest
  include DefaultCrudTokenNecessityTest
  include DefaultCrudManagerAuthorizationTest

  setup do
    manager = create :user, :manager
    token = auth_token(manager)

    @tariff = create :tariff

    @tariff_attrs = attributes_for :tariff

    include_content_type_header
    include_auth_header(token)
  end

  test 'should require token for custom actions' do
    include_auth_header('invalid_token')

    get :kinds
    assert_response :forbidden
  end

  test 'should get tariffs list' do
    get :index, params: { page: 1, per_page: 25 }
    assert_response :success

    assert response_body.dig('data', 'tariffs')&.any?
  end

  test 'should not get custom actions unless role is manager' do
    not_managers.each do |u|
      token = auth_token(u)
      include_auth_header(token)

      get :kinds
      assert_response :unauthorized
    end
  end

  test 'should create tariff' do
    assert_difference('Tariff.count', 1) do
      post :create, params: { tariff: @tariff_attrs }
    end

    assert response_body.dig('data', 'id').present?
    assert_response :success
  end

  test 'should not create with invalid data' do
    @tariff_attrs[:value] = -100.0
    post :create, params: { tariff: @tariff_attrs }

    assert response_body.dig('errors', 'value')&.any?
    assert_response :unprocessable_entity
  end

  test 'should update tariff' do
    new_value = @tariff.value + 5
    put :update, params: { id: @tariff.id, tariff: { value: new_value } }

    assert_equal @tariff.reload.value, new_value
    assert_response :success
  end

  test 'should not update with invalid data' do
    old_value = @tariff.value

    put :update, params: { id: @tariff.id, tariff: { value: -100.0 } }

    assert_equal @tariff.reload.value, old_value
    assert response_body.dig('errors', 'value')&.any?
    assert_response :unprocessable_entity
  end

  test 'should destroy tariff' do
    assert_difference('Tariff.count', -1) do
      delete :destroy, params: { id: @tariff.id }
    end

    assert_response :success
  end

  test 'should get kinds' do
    get :kinds
    assert_response :success

    assert response_body.dig('data', 'kinds')&.any?
  end
end
