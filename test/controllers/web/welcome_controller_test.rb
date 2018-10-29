require 'test_helper'

class Web::WelcomeControllerTest < ActionController::TestCase
  test 'not authorized user' do
    get :index

    assert_response :success
    assert_empty @response.body
  end

  test 'redirect to user root' do
    user = create :user
    sign_in user

    get :index

    assert_response :success
    assert_empty @response.body
  end

  test 'redirect to admin root' do
    admin = create :user, :admin
    sign_in admin

    get :index
    assert_redirected_to admin_root_path
  end

  test 'redirect to manager root' do
    admin = create :user, :manager
    sign_in admin

    get :index

    assert_response :success
    assert_empty @response.body
  end
end
