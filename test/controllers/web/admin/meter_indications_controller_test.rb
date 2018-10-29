require 'test_helper'

class Web::Admin::MeterIndicationsControllerTest < ActionController::TestCase
  setup do
    @admin = create :user, :admin
    sign_in @admin

    create :meter_indication
  end

  test 'index' do
    get :index
    assert_response :success
  end
end
