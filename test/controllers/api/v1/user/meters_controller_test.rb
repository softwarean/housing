require 'test_helper'

class Api::V1::User::MetersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
    token = auth_token(@user)

    @headers = integration_test_headers(token)

    account = create :account_with_users, users: [@user]
    meter_cold = create :meter, account_number: account.account_number
    meter_hot = create :meter, :hot_water_meter, account_number: account.account_number
    meter_electricity = create :meter, :electricity_meter, account_number: account.account_number

    generate_indications(meter_cold)
    generate_indications(meter_hot)
    generate_indications(meter_electricity)

    create :tariff, :cold_water
    create :tariff, :hot_water
    create :tariff, :electricity_daily
    create :tariff, :electricity_nightly

    MeterIndicationsReducingJob.perform
  end

  test 'should require token' do
    headers_with_invalid_token = integration_test_headers('invalid_token')

    get api_v1_user_meters_path, headers: headers_with_invalid_token
    assert_response :forbidden

    get api_v1_user_meters_details_path('cold_water'), params: { kind: :cold_water }, headers: headers_with_invalid_token
    assert_response :forbidden
  end

  test 'should get common meters data for current day' do
    get api_v1_user_meters_path, params: { segment: ::Constants::CURRENT_DAY_SEGMENT }, headers: @headers

    inspect_index_response
  end

  test 'should get common meters data for month' do
    get api_v1_user_meters_path, params: { segment: Date.current.month }, headers: @headers

    inspect_index_response
  end

  test 'should get common meters data for year' do
    get api_v1_user_meters_path, params: { segment: ::Constants::YEAR_SEGMENT }, headers: @headers

    inspect_index_response
  end

  test 'should not get index without segment' do
    get api_v1_user_meters_path, headers: @headers

    assert_response :unprocessable_entity
  end

  test 'should not get index with wrong segment' do
    get api_v1_user_meters_path, params: { segment: 'wrong_segment' }, headers: @headers

    assert_response :unprocessable_entity
  end

  test 'should get show for current day' do
    get api_v1_user_meters_details_path('cold_water'),
      params: { segment: ::Constants::CURRENT_DAY_SEGMENT }, headers: @headers

    inspect_show_response
  end

  test 'should get show for month' do
    get api_v1_user_meters_details_path('cold_water'),
      params: { segment: Date.current.month }, headers: @headers

    inspect_show_response
  end

  test 'should get show for year' do
    get api_v1_user_meters_details_path('cold_water'),
      params: { segment: ::Constants::YEAR_SEGMENT }, headers: @headers

    inspect_show_response
  end

  test 'should not get show without segment' do
    get api_v1_user_meters_details_path('cold_water'), headers: @headers

    assert_response :unprocessable_entity
  end

  test 'should not get show with wrong kind' do
    get api_v1_user_meters_details_path('wrong_kind'), params: { segment: ::Constants::YEAR_SEGMENT }, headers: @headers

    assert_response :unprocessable_entity
  end

  test 'should not get show with wrong segment' do
    get api_v1_user_meters_details_path('cold_water'), params: { segment: 'wrong_segment' }, headers: @headers

    assert_response :unprocessable_entity
  end

  private

  def inspect_index_response
    assert_response :success
    assert response_body.dig('data', 'diffs_data').present?

    diffs_data = response_body['data']['diffs_data']
    diffs_data.each do |data|
      check_diffs_data(data)
    end
  end

  def inspect_show_response
    assert_response :success
    assert response_body.dig('data', 'diffs_data').present?

    diffs_data = response_body['data']['diffs_data']
    check_diffs_data(diffs_data)
  end

  def check_diffs_data(data)
    assert ['cold_water_meter', 'hot_water_meter', 'electricity_meter'].include?(data['type'])
    assert data['tariff'].present? || (data['daily_tariff'].present? && data['daily_tariff'].present?)
    assert data.dig('data')&.any?
  end
end
