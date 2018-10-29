require 'test_helper'

class Web::Admin::AccountsControllerTest < ActionController::TestCase
  setup do
    admin = create :user, :admin
    sign_in admin

    @account = create :account

    apartment = create :apartment
    @account_attrs = attributes_for :account
    @account_attrs[:apartment_id] = apartment.id
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
    assert_difference('Account.count', 1) do
      post :create, params: { account: @account_attrs }
    end
    assert_redirected_to admin_accounts_path
  end

  test 'create with wrong params rerenders new' do
    @account_attrs[:account_number] = nil

    post :create, params: { account: @account_attrs }
    assert_template :new
  end

  test 'should get edit' do
    get :edit, params: { id: @account.id }
    assert_response :success
  end

  test 'should update' do
    new_number = generate(:string)
    put :update, params: { id: @account.id, account: { account_number: new_number } }

    assert_equal @account.reload.account_number, new_number
    assert_redirected_to admin_accounts_path
  end

  test 'update with wrong params rerenders edit' do
    @account_attrs[:account_number] = nil

    put :update, params: { id: @account.id, account: @account_attrs }
    assert_template :edit
  end

  test 'should destroy' do
    assert_difference('Account.count', -1) do
      delete :destroy, params: { id: @account.id }
    end

    assert_redirected_to admin_accounts_path
  end
end
