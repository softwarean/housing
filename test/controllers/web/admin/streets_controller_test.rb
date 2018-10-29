require 'test_helper'

class Web::Admin::StreetsControllerTest < ActionController::TestCase
  setup do
    @admin = create :user, :admin
    sign_in @admin

    @street = create :street
    @street_attrs = attributes_for :street
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create' do
    assert_difference('Street.count', 1) do
      post :create, params: { street: @street_attrs }
    end

    assert_redirected_to admin_streets_path
  end

  test 'create with wrong params rerenders new' do
    @street_attrs[:name] = nil

    post :create, params: { street: @street_attrs }
    assert_template :new
  end

  test 'should get edit' do
    get :edit, params: { id: @street.id }
    assert_response :success
  end

  test 'should update' do
    new_name = generate(:string)
    put :update, params: { id: @street.id, street: { name: new_name } }

    @street.reload

    assert_equal @street.name, new_name
    assert_response :redirect
  end

  test 'update with wrong params rerenders edit' do
    @street_attrs[:name] = nil

    put :update, params: { id: @street.id, street: @street_attrs }
    assert_template :edit
  end

  test 'should destroy' do
    assert_difference('Street.count', -1) do
      delete :destroy, params: { id: @street.id }
    end
    assert_redirected_to admin_streets_path
  end

  test 'destroy with houses redirects to index' do
    create :house, street: @street

    assert_no_difference('Street.count') do
      delete :destroy, params: { id: @street.id }
    end
    assert_redirected_to admin_streets_path
    assert_not_empty(flash[:error])
  end
end
