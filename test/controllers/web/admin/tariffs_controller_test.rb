require 'test_helper'

class Web::Admin::TariffsControllerTest < ActionController::TestCase
  setup do
    admin = create :user, :admin
    sign_in admin

    @user = create :user
    @manager = create :user, :manager

    @tariff = create :tariff
    @tariff_attrs = attributes_for :tariff
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
    assert_difference('Tariff.count', 1) do
      post :create, params: { tariff: @tariff_attrs }
    end
    assert_redirected_to admin_tariffs_path
  end

  test 'create with wrong params rerenders new' do
    @tariff_attrs[:value] = -10

    post :create, params: { tariff: @tariff_attrs }
    assert_template :new
  end

  test 'should get edit' do
    get :edit, params: { id: @tariff.id }
    assert_response :success
  end

  test 'should update' do
    new_name = generate(:name)
    put :update, params: { id: @tariff.id, tariff: { name: new_name } }
    assert_equal @tariff.reload.name, new_name
    assert_response :redirect
  end

  test 'update with wrong params rerenders edit' do
    @tariff_attrs[:value] = -10

    put :update, params: { id: @tariff.id, tariff: @tariff_attrs }
    assert_template :edit
  end

  test 'should destroy' do
    assert_difference('Tariff.count', -1) do
      delete :destroy, params: { id: @tariff.id }
    end

    assert_redirected_to admin_tariffs_path
  end
end
