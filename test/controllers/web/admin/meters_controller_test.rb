require 'test_helper'

class Web::Admin::MetersControllerTest < ActionController::TestCase
  setup do
    @admin = create :user, :admin
    sign_in @admin

    @meter = create :meter
    create :meter_indication, meter_uuid: @meter.uuid
  end

  test 'index' do
    get :index
    assert_response :success
  end

  test 'show' do
    get :show, params: { id: @meter }
    assert_response :success
  end
end
