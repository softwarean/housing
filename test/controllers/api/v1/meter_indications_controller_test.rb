require 'test_helper'

class Api::V1::MeterIndicationsControllerTest < ActionController::TestCase
  setup do
    @meter_indication_attrs = attributes_for :meter_indication

    include_content_type_header
  end

  test 'create' do
    assert_difference('MeterIndication.count', 1) do
      post :create, format: :json, params: { meter_indication: @meter_indication_attrs }
    end

    assert_response :success
  end

  test 'create not valid json' do
    not_valid_attributes = { 'test': 'test' }

    post :create, format: :json, params: { meter_indication: not_valid_attributes }
    assert_response :unprocessable_entity
  end

  test 'not acceptable content type' do
    @request.headers['Content-Type'] = Mime[:xml].to_s
    post :create, format: :json, params: { meter_indication: @meter_indication_attrs }

    assert_response :not_acceptable
  end
end
