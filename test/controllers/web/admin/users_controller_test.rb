require 'test_helper'

class Web::Admin::UsersControllerTest < ActionController::TestCase
  setup do
    @user = create :user
    @admin = create :user, :admin
    sign_in @admin
    @user_attrs = attributes_for :user
  end

  test 'index' do
    get :index
    assert_response :success
  end

  test 'new' do
    get :new
    assert_response :success
  end

  test 'create' do
    assert_difference('User.count', 1) do
      post :create, params: { user: @user_attrs }
    end
    assert_redirected_to admin_users_path
  end

  test 'create with wrong params rerenders new' do
    @user_attrs[:email] = 'not valid email'

    post :create, params: { user: @user_attrs }
    assert_template :new
  end

  test 'edit' do
    get :edit, params: { id: @user.id }
    assert_response :success
  end

  test 'update' do
    new_email = generate(:email)
    put :update, params: { id: @user.id, user: { email: new_email } }
    assert_equal @user.reload.email, new_email
    assert_response :redirect
  end

  test 'update with wrong params rerenders edit' do
    @user_attrs[:email] = 'not valid email'

    put :update, params: { id: @user.id, user: @user_attrs }
    assert_template :edit
  end

  test 'destroy' do
    assert_difference('User.count', -1) do
      delete :destroy, params: { id: @user.id }
    end
    assert_redirected_to admin_users_path
  end
end
