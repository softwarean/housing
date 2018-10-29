require 'test_helper'

class Api::V1::Manager::HousesControllerTest < ActionController::TestCase
  include IndexPaginationTest
  include DefaultCrudTokenNecessityTest
  include DefaultCrudManagerAuthorizationTest

  setup do
    manager = create :user, :manager
    token = auth_token(manager)

    @house = create :house

    include_content_type_header
    include_auth_header(token)
  end

  test 'should get index' do
    get :index, params: { page: 1, per_page: 25 }
    assert_response :success

    assert response_body.dig('data', 'houses')&.any?
  end

  test 'should get filtered data from index' do
    street1 = create :street
    street2 = create :street

    house1 = create :house, street: street1
    create :house, street: street2

    q = { street_id_eq: street1.id }

    get :index, params: { page: 1, per_page: 25, q: q }
    assert_response :success

    assert response_body.dig('data', 'houses')&.any?

    result_houses_ids = response_body['data']['houses'].map { |record| record['id'] }
    assert_equal result_houses_ids.count, 1
    assert_equal result_houses_ids.first, house1.id
  end

  test 'filtration by not permitted attributes should not work' do
    street1 = create :street
    street2 = create :street

    house1 = create :house, street: street1
    house2 = create :house, street: street2

    q = { street_name_eq: street1.name }

    get :index, params: { page: 1, per_page: 25, q: q }
    assert_response :success

    assert response_body.dig('data', 'houses')&.any?

    houses_ids = [@house, house1, house2].map(&:id)
    result_houses_ids = response_body['data']['houses'].map { |record| record['id'] }
    assert_equal houses_ids.count, result_houses_ids.count
    assert_empty houses_ids - result_houses_ids
  end

  test 'should get count' do
    get :count

    assert_response :success

    houses_count = response_body.dig('data', 'count')

    assert houses_count.present?
    assert_equal houses_count, 1
  end
end
