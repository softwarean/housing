require 'test_helper'

class Web::Admin::HousesControllerTest < ActionController::TestCase
  setup do
    @admin = create :user, :admin
    sign_in @admin

    @house = create :house
    street = create :street
    @house_attrs = attributes_for :house
    @house_attrs[:street_id] = street.id
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
    assert_difference('House.count', 1) do
      post :create, params: { house: @house_attrs }
    end

    assert_redirected_to admin_houses_path
  end

  test 'create with wrong params rerenders new' do
    @house_attrs[:house_number] = nil

    post :create, params: { house: @house_attrs }
    assert_template :new
  end

  test 'should get edit' do
    get :edit, params: { id: @house.id }
    assert_response :success
  end

  test 'should update' do
    new_house_number = generate(:string)
    put :update, params: { id: @house.id, house: { house_number: new_house_number } }

    @house.reload

    assert_equal @house.house_number, new_house_number
    assert_response :redirect
  end

  test 'update with wrong params rerenders edit' do
    @house_attrs[:house_number] = nil

    put :update, params: { id: @house.id, house: @house_attrs }
    assert_template :edit
  end

  test 'should destroy' do
    assert_difference('House.count', -1) do
      delete :destroy, params: { id: @house.id }
    end
    assert_redirected_to admin_houses_path
  end

  test 'destroy with apartments redirects to index' do
    create :apartment, house: @house

    assert_no_difference('House.count') do
      delete :destroy, params: { id: @house.id }
    end
    assert_redirected_to admin_houses_path
    assert_not_empty(flash[:error])
  end
end
