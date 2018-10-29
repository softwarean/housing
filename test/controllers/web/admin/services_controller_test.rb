require 'test_helper'

class Web::Admin::ServicesControllerTest < ActionController::TestCase
  setup do
    admin = create :user, :admin
    sign_in admin

    @user = create :user
    @manager = create :user, :manager

    @service = create :service
    @service_attrs = attributes_for :service
  end

  test 'admin should get index' do
    get :index
    assert_response :success
  end

  test 'should not get index' do
    sign_in @user

    get :index
    assert_redirected_to login_path

    sign_in @manager

    get :index
    assert_redirected_to login_path
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create' do
    assert_difference('Service.count', 1) do
      post :create, params: { service: @service_attrs }
    end
    assert_redirected_to admin_services_path
  end

  test 'create with wrong params rerenders new' do
    @service_attrs[:cost] = -10

    post :create, params: { service: @service_attrs }
    assert_template :new
  end

  test 'should get edit' do
    get :edit, params: { id: @service.id }
    assert_response :success
  end

  test 'should update' do
    new_name = generate(:name)
    put :update, params: { id: @service.id, service: { name: new_name } }
    assert_equal @service.reload.name, new_name
    assert_response :redirect
  end

  test 'update with wrong params rerenders edit' do
    @service_attrs[:cost] = -10

    put :update, params: { id: @service.id, service: @service_attrs }
    assert_template :edit
  end

  test 'should destroy' do
    assert_difference('Service.count', -1) do
      delete :destroy, params: { id: @service.id }
    end

    assert_redirected_to admin_services_path
  end
end
