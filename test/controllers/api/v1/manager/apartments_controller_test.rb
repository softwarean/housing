require 'test_helper'

class Api::V1::Manager::ApartmentsControllerTest < ActionController::TestCase
  include IndexPaginationTest
  include DefaultCrudTokenNecessityTest
  include DefaultCrudManagerAuthorizationTest

  setup do
    manager = create :user, :manager
    token = auth_token(manager)

    @apartment = create :apartment

    include_content_type_header
    include_auth_header(token)
  end

  test 'should get index' do
    get :index, params: { page: 1, per_page: 25 }
    assert_response :success

    assert response_body.dig('data', 'apartments')&.any?
  end

  test 'should get filtered data from index' do
    house1 = create :house
    house2 = create :house

    apartment1 = create :apartment, house: house1
    create :apartment, house: house2

    q = { house_id_eq: house1.id }

    get :index, params: { page: 1, per_page: 25, q: q }
    assert_response :success

    assert response_body.dig('data', 'apartments')&.any?

    result_apartments_ids = response_body['data']['apartments'].map { |record| record['id'] }
    assert_equal result_apartments_ids.count, 1
    assert_equal result_apartments_ids.first, apartment1.id
  end

  test 'filtration by not permitted attributes should not work' do
    house1 = create :house
    house2 = create :house

    apartment1 = create :apartment, house: house1
    apartment2 = create :apartment, house: house2

    q = { house_number_eq: house1.house_number }

    get :index, params: { page: 1, per_page: 25, q: q }
    assert_response :success

    assert response_body.dig('data', 'apartments')&.any?

    apartments_ids = [@apartment, apartment1, apartment2].map(&:id)
    result_apartments_ids = response_body['data']['apartments'].map { |record| record['id'] }
    assert_equal apartments_ids.count, result_apartments_ids.count
    assert_empty apartments_ids - result_apartments_ids
  end

  test 'should get count' do
    get :count

    assert_response :success

    houses_count = response_body.dig('data', 'count')

    assert houses_count.present?
    assert_equal houses_count, 1
  end
end
