require 'test_helper'

class Web::SessionsControllerTest < ActionController::TestCase
  setup do
    @user = create :user
    @manager = create :user, :manager
    @admin = create :user, :admin
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create' do
    post :create, params: { web_sign_in_type: { email: @admin.email, password: @admin.password } }
    assert_redirected_to admin_root_path
  end

  test 'should not create for plain user and manager' do
    # Обычные пользователи и менеджеры ходят через SPA, соответственно, аутентификацией занимается API
    [@user, @manager].each do |u|
      post :create, params: { web_sign_in_type: { email: u.email, password: u.password } }
      assert_template :new
    end
  end

  test 'should destroy' do
    sign_in @user

    delete :destroy
    assert_redirected_to login_path
  end

  test 'user not found rerenders new' do
    post :create, params: { web_sign_in_type: { email: 'wrong@test.test', password: @admin.password } }
    assert_template :new
  end

  test 'authentication error renders new' do
    post :create, params: { web_sign_in_type: { email: @admin.email, password: 'wrongpassword' } }
    assert_template :new
  end
end
