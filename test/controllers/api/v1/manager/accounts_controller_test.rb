require 'test_helper'

class Api::V1::Manager::AccountsControllerTest < ActionController::TestCase
  include IndexPaginationTest
  include DefaultCrudTokenNecessityTest
  include DefaultCrudManagerAuthorizationTest

  setup do
    manager = create :user, :manager
    token = auth_token(manager)

    @account = create :account

    apartment = create :apartment
    @account_attrs = attributes_for :account
    @account_attrs[:apartment_id] = apartment.id

    include_content_type_header
    include_auth_header(token)
  end

  test 'should get index' do
    get :index, params: { page: 1, per_page: 25 }
    assert_response :success

    assert response_body.dig('data', 'accounts')&.any?
  end

  test 'should create account' do
    assert_difference('Account.count', 1) do
      post :create, params: { account: @account_attrs }
    end

    assert response_body.dig('data', 'id').present?
    assert_response :success
  end

  test 'should not create with invalid data' do
    another_account = create :account
    @account_attrs[:account_number] = another_account.account_number

    post :create, params: { account: @account_attrs }

    assert response_body.dig('errors', 'account_number')&.any?
    assert_response :unprocessable_entity
  end

  test 'should update account' do
    new_number = generate(:string)
    put :update, params: { id: @account.id, account: { account_number: new_number } }

    assert_equal @account.reload.account_number, new_number
    assert_response :success
  end

  test 'should not update with invalid data' do
    old_account_number = @account.account_number

    another_account = create :account

    put :update, params: { id: @account.id, account: { account_number: another_account.account_number } }

    assert_equal @account.reload.account_number, old_account_number
    assert response_body.dig('errors', 'account_number')&.any?
    assert_response :unprocessable_entity
  end

  test 'should destroy account' do
    assert_difference('Account.count', -1) do
      delete :destroy, params: { id: @account.id }
    end

    assert_response :success
  end
end
