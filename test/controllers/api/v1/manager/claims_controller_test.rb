require 'test_helper'

class Api::V1::Manager::ClaimsControllerTest < ActionController::TestCase
  include IndexPaginationTest
  include DefaultCrudTokenNecessityTest
  include DefaultCrudManagerAuthorizationTest

  setup do
    manager = create :user, :manager
    token = auth_token(manager)

    @claim = create :claim

    service = create :service
    user = create :user
    @claim_attrs = attributes_for :claim
    @claim_attrs[:service_id] = service.id
    @claim_attrs[:user_id] = user.id

    include_content_type_header
    include_auth_header(token)
  end

  test 'should get index' do
    get :index, params: { page: 1, per_page: 25 }
    assert_response :success

    assert response_body.dig('data', 'claims')&.any?
  end

  test 'should create claim' do
    assert_difference('Claim.count', 1) do
      post :create, params: { claim: @claim_attrs }
    end

    assert response_body.dig('data', 'id').present?
    assert_response :success
  end

  test 'should not create claim with invalid data' do
    @claim_attrs[:deadline] = DateTime.current - 1.day
    post :create, params: { claim: @claim_attrs }

    assert response_body.dig('errors', 'deadline')&.any?
    assert_response :unprocessable_entity
  end

  test 'should not create claim with state other than initial' do
    @claim_attrs[:state] = 'completed'
    post :create, params: { claim: @claim_attrs }

    claim_id = response_body['data']['id']
    claim = Claim.find claim_id

    assert_equal claim.aasm_state, 'new'
  end

  test 'should update claim' do
    new_state = 'in_processing'
    put :update, params: { id: @claim.id, claim: { aasm_state: new_state } }

    assert_equal @claim.reload.aasm_state, new_state
    assert_response :success
  end

  test 'should not update claim state if transition is impossible' do
    old_state = @claim.aasm_state
    new_state = 'completed'
    put :update, params: { id: @claim.id, claim: { aasm_state: new_state } }

    assert_equal @claim.reload.aasm_state, old_state
    assert response_body.dig('errors', 'aasm_state')&.any?
    assert_response :unprocessable_entity
  end

  test 'should destroy claim' do
    assert_difference('Claim.count', -1) do
      delete :destroy, params: { id: @claim.id }
    end

    assert_response :success
  end
end
