require 'test_helper'

class Web::Admin::ApartmentsControllerTest < ActionController::TestCase
  NUMBER_OF_APARTMENTS = 3

  setup do
    @admin = create :user, :admin
    sign_in @admin

    @apartment = create :apartment
    house = create :house
    @apartments_creation_type_attrs = { house_id: house.id, number_of_apartments: NUMBER_OF_APARTMENTS }
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
    assert_difference('Apartment.count', NUMBER_OF_APARTMENTS) do
      post :create, params: { apartments_creation_type: @apartments_creation_type_attrs }
    end

    assert_redirected_to admin_apartments_path
  end

  test 'create with wrong params rerenders new' do
    @apartments_creation_type_attrs[:number_of_apartments] = nil

    assert_no_difference('Apartment.count') do
      post :create, params: { apartments_creation_type: @apartments_creation_type_attrs }
    end

    assert_template :new
  end

  test 'should destroy' do
    assert_difference('Apartment.count', -1) do
      delete :destroy, params: { id: @apartment.id }
    end

    assert_redirected_to admin_apartments_path
    assert_nil(flash[:alert])
  end

  test 'destroy with account redirects to index' do
    account = create :account
    apartment = create :apartment, account: account

    assert_no_difference('Apartment.count') do
      delete :destroy, params: { id: apartment.id }
    end

    assert_redirected_to admin_apartments_path
    assert_not_empty(flash[:alert])
  end

  test 'should destroy via ajax' do
    assert_difference('Apartment.count', -1) do
      delete :destroy, format: :js, params: { id: @apartment.id }
    end

    assert_response :success
    assert_equal(response.body, "$(\"#index-apartment-#{@apartment.id}\").remove();\n")
  end

  test 'should not destroy with account via ajax' do
    account = create :account
    apartment = create :apartment, account: account

    assert_no_difference('Apartment.count') do
      delete :destroy, format: :js, params: { id: apartment.id }
    end

    assert_match('alert', response.body)
  end
end
