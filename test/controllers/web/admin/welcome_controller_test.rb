require 'test_helper'

class Web::Admin::WelcomeControllerTest < ActionController::TestCase
  test 'not authorized user' do
    get :index
    assert_redirected_to login_path
  end

  test 'not authorized admin' do
    user = create :user
    sign_in user

    get :index
    assert_redirected_to login_path
  end

  test 'redirect to admin root' do
    admin = create :user, :admin
    sign_in admin

    get :index
    assert_redirected_to admin_users_path
  end
end
