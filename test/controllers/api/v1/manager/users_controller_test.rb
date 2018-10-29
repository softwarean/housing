require 'test_helper'

class Api::V1::Manager::UsersControllerTest < ActionController::TestCase
  include IndexPaginationTest
  include DefaultCrudTokenNecessityTest
  include DefaultCrudManagerAuthorizationTest

  setup do
    manager = create :user, :manager
    token = auth_token(manager)

    @user = create :user_with_accounts
    @manager = create :user, :manager
    @admin = create :user, :admin

    account = create :account
    @user_attrs = attributes_for :user
    @user_attrs[:account_ids] = [account.id]

    include_content_type_header
    include_auth_header(token)
  end

  test 'should get index' do
    get :index, params: { page: 1, per_page: 25 }
    assert_response :success

    assert response_body.dig('data', 'users')&.any?
  end

  test 'should create user' do
    assert_difference('User.count', 1) do
      post :create, params: { user: @user_attrs }
    end

    assert response_body.dig('data', 'id').present?
    assert_response :success
  end

  test 'should not create with invalid data' do
    @user_attrs[:email] = 'not an email'
    post :create, params: { user: @user_attrs }

    assert response_body.dig('errors', 'email')&.any?
    assert_response :unprocessable_entity
  end

  test 'should not create without accounts' do
    user_attrs_without_accounts = attributes_for :user

    assert_no_difference('User.count') do
      post :create, params: { user: user_attrs_without_accounts }
    end

    assert response_body.dig('errors', 'account_ids')&.any?
    assert_response :unprocessable_entity
  end

  test 'manager can not create user with role different from "user"' do
    @user_attrs[:role] = 'manager'

    assert_difference('User.where(role: :user).count', 1) do
      assert_no_difference('User.where(role: :manager).count') do
        post :create, params: { user: @user_attrs }
      end
    end
  end

  test 'should update user' do
    new_name = generate(:string)
    put :update, params: { id: @user.id, user: { name: new_name } }

    assert_equal @user.reload.name, new_name
    assert_response :success
  end

  test 'should not update with invalid data' do
    old_email = @user.email

    put :update, params: { id: @user.id, user: { email: 'not an email' } }

    assert_equal @user.reload.email, old_email
    assert response_body.dig('errors', 'email')&.any?
    assert_response :unprocessable_entity
  end

  test 'should not update without accounts' do
    user_without_accounts = create :user

    new_email = generate(:email)
    put :update, params: { id: user_without_accounts.id, user: { email: new_email } }

    assert_not_equal user_without_accounts.reload.email, new_email
    assert response_body.dig('errors', 'accounts')&.any?
    assert_response :unprocessable_entity
  end

  test 'manager can not update managers and admins' do
    [@manager, @admin].each do |user|
      new_email = generate(:email)

      put :update, params: { id: user.id, user: { email: new_email } }

      assert_response :not_found
      assert_not_equal user.reload.email, new_email
    end
  end

  test 'manager can not update role' do
    new_role = 'manager'
    put :update, params: { id: @user.id, user: { role: new_role } }
    assert_not_equal @user.reload.role, new_role
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete :destroy, params: { id: @user.id }
    end

    assert_response :success
  end

  test 'manager can not destroy managers and admins' do
    [@manager, @admin].each do |user|
      delete :destroy, params: { id: user.id }
      assert_response :not_found
    end
  end
end
