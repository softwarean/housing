require 'test_helper'

class Api::V1::Manager::MetersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = create :user, :manager
    token = auth_token(@manager)

    @headers = integration_test_headers(token)

    account = create :account
    @house = create :house
    @apartment = create :apartment, house: @house, account: account

    common_house_meters = [:cold_water_meter, :hot_water_meter, :electricity_meter].map do |kind|
      create :meter, kind, account_number: nil, house_id: @house.id
    end

    apartment_meters = [:cold_water_meter, :hot_water_meter, :electricity_meter].map do |kind|
      create :meter, kind, account_number: account.account_number
    end

    [*common_house_meters, *apartment_meters].each { |meter| generate_indications(meter) }

    [:cold_water, :hot_water, :electricity_daily, :electricity_nightly].each { |kind| create :tariff, kind }

    MeterIndicationsReducingJob.perform
  end

  test 'should require token' do
    headers_with_invalid_token = integration_test_headers('invalid_token')

    paths = [
      houses_data_api_v1_manager_meters_path,
      apartments_data_api_v1_manager_meters_path,
      apartment_details_api_v1_manager_meters_path,
      apartment_service_details_api_v1_manager_meters_path('cold_water')
    ]

    paths.each do |path|
      get path, params: { kind: :cold_water }, headers: headers_with_invalid_token
      assert_response :forbidden
    end
  end

  test 'should get houses data for current day' do
    get houses_data_api_v1_manager_meters_path, params: { segment: ::Constants::CURRENT_DAY_SEGMENT }, headers: @headers

    inspect_houses_data_response
  end

  test 'should get houses data for month' do
    get houses_data_api_v1_manager_meters_path, params: { segment: Date.current.month }, headers: @headers

    inspect_houses_data_response
  end

  test 'should get houses data for year' do
    get houses_data_api_v1_manager_meters_path, params: { segment: ::Constants::YEAR_SEGMENT }, headers: @headers

    inspect_houses_data_response
  end

  test 'should filter streets on getting houses data' do
    street_names = ['Можайское шоссе', 'Можжевеловая улица', 'Некрасова улица']

    streets = street_names.map { |n| create :street, name: n }
    houses = streets.map { |s| create :house, street: s }
    meters = houses.map { |h| create :meter, account_number: nil, house_id: h.id }

    meters.each { |meter| generate_indications(meter) }

    MeterIndicationsReducingJob.perform

    get houses_data_api_v1_manager_meters_path, params: { segment: ::Constants::CURRENT_DAY_SEGMENT, street_name_cont: 'Мож' }, headers: @headers
    assert_response :success

    data = response_body.dig('data')
    assert data&.any?

    received_streets = data.map { |d| d.dig('street') }
    assert_equal(received_streets.count, 2)

    difference = street_names - received_streets
    assert_equal(difference.first, street_names.last)
  end

  test 'should get apartments_data for current day' do
    get apartments_data_api_v1_manager_meters_path,
      params: { segment: ::Constants::CURRENT_DAY_SEGMENT, house_id: @house.id }, headers: @headers

    inspect_apartments_data_response
  end

  test 'should get apartments_data for month' do
    get apartments_data_api_v1_manager_meters_path,
      params: { segment: Date.current.month, house_id: @house.id }, headers: @headers

    inspect_apartments_data_response
  end

  test 'should get apartments_data for year' do
    get apartments_data_api_v1_manager_meters_path,
      params: { segment: ::Constants::YEAR_SEGMENT, house_id: @house.id }, headers: @headers

    inspect_apartments_data_response
  end

  test 'should get apartment_details for current day' do
    get apartment_details_api_v1_manager_meters_path,
      params: { segment: ::Constants::CURRENT_DAY_SEGMENT, apartment_id: @apartment.id }, headers: @headers

    inspect_apartment_response
  end

  test 'should get apartment_details for month' do
    get apartment_details_api_v1_manager_meters_path,
      params: { segment: Date.current.month, apartment_id: @apartment.id }, headers: @headers

    inspect_apartment_response
  end

  test 'should get apartment_details for year' do
    get apartment_details_api_v1_manager_meters_path,
      params: { segment: ::Constants::YEAR_SEGMENT, apartment_id: @apartment.id }, headers: @headers

    inspect_apartment_response
  end

  test 'should get apartment_details_by_service for current day' do
    get apartment_service_details_api_v1_manager_meters_path('cold_water'),
      params: { segment: ::Constants::CURRENT_DAY_SEGMENT, apartment_id: @apartment.id }, headers: @headers

    inspect_apartment_response
  end

  test 'should get apartment_details_by_service for month' do
    get apartment_service_details_api_v1_manager_meters_path('cold_water'),
      params: { segment: Date.current.month, apartment_id: @apartment.id }, headers: @headers

    inspect_apartment_response
  end

  test 'should get apartment_details_by_service for year' do
    get apartment_service_details_api_v1_manager_meters_path('cold_water'),
      params: { segment: ::Constants::YEAR_SEGMENT, apartment_id: @apartment.id }, headers: @headers

    inspect_apartment_response
  end

  private

  def inspect_houses_data_response
    assert_response :success

    data = response_body.dig('data')
    assert data&.any?

    data.each do |d|
      assert d.dig('street').present?

      houses = d.dig('houses')

      assert houses&.any?

      houses.each do |h|
        assert h.dig('id').present?
        assert h.dig('number').present?
        assert h.dig('claims_count').present?

        diffs_data = h.dig('diffs_data')

        assert diffs_data&.any?
      end
    end
  end

  def inspect_apartments_data_response
    assert_response :success

    data = response_body.dig('data')
    assert data.present?
    assert data.dig('house').present?

    apartments_data = data.dig('data')
    assert apartments_data&.any?

    apartments_data.each do |d|
      assert d.dig('id').present?
      assert d.dig('number').present?
      assert d.dig('claims_count').present?
      assert d.dig('diffs_data')&.any?
    end
  end

  def inspect_apartment_response
    assert_response :success

    data = response_body.dig('data')

    assert data.present?
    assert data.dig('diffs_data').present?

    account_info = data.dig('account_info')

    assert account_info.present?
    assert account_info.dig('address').present?
    assert account_info.dig('account_number').present?
  end
end
