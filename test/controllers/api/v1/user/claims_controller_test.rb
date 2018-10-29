require 'test_helper'

class Api::V1::User::ClaimsControllerTest < ActionController::TestCase
  include DefaultCrudTokenNecessityTest

  setup do
    @user = create :user
    @token = auth_token(@user)

    @claim = create :claim, applicant: @user

    service = create :service
    @claim_attrs = attributes_for :claim
    @claim_attrs[:service_id] = service.id

    include_content_type_header
    include_auth_header(@token)
  end

  test 'should get claims list' do
    get :index
    assert_response :success

    assert response_body.dig('data', 'claims')&.any?
    assert_equal response_body['data']['claims'].first['id'], @claim.id
  end

  test 'should create a new claim' do
    assert_difference("Claim.for_user(#{@user.id}).count", 1) do
      post :create, params: { claim: @claim_attrs }
    end

    assert response_body.dig('data', 'id').present?
    assert_response :success
  end

  test 'can not create without service_id' do
    @claim_attrs.delete(:service_id)

    assert_no_difference('Claim.count') do
      post :create, params: { claim: @claim_attrs }
    end

    assert response_body.dig('errors', 'service_id')&.any?
    assert_response :unprocessable_entity
  end

  test 'can not create without deadline' do
    @claim_attrs.delete(:deadline)

    assert_no_difference('Claim.count') do
      post :create, params: { claim: @claim_attrs }
    end

    assert response_body.dig('errors', 'deadline')&.any?
    assert_response :unprocessable_entity
  end

  test 'can not create with deadline in the past' do
    @claim_attrs[:deadline] = DateTime.current - 1.month

    assert_no_difference('Claim.count') do
      post :create, params: { claim: @claim_attrs }
    end

    assert response_body.dig('errors', 'deadline')&.any?
    assert_response :unprocessable_entity
  end

  test 'user can not create claim for another user' do
    another_user = create :user
    @claim_attrs['user_id'] = another_user.id

    assert_difference("Claim.for_user(#{@user.id}).count", 1) do
      assert_no_difference("Claim.for_user(#{another_user.id}).count") do
        post :create, params: { claim: @claim_attrs }
      end
    end

    assert_response :success
  end
end
