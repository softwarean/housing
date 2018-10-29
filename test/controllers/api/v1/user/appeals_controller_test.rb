require 'test_helper'

class Api::V1::User::AppealsControllerTest < ActionController::TestCase
  include DefaultCrudTokenNecessityTest

  setup do
    @appeal = create :appeal

    @user = create :user
    @token = auth_token(@user)

    @appeal = create :appeal, user: @user
    @appeal_attrs = attributes_for :appeal

    include_content_type_header
    include_auth_header(@token)
  end

  test 'should get appeals list' do
    get :index
    assert_response :success

    assert response_body.dig('data', 'appeals')&.any?
    assert_equal response_body['data']['appeals'].first['id'], @appeal.id
  end

  test 'should get certain appeal' do
    get :show, params: { id: @appeal.id }
    assert_response :success

    assert response_body.dig('data', 'appeal').present?
    assert_equal response_body['data']['appeal']['id'], @appeal.id
  end

  test 'should not get another user appeal' do
    another_user = create :user
    another_appeal = create :appeal, user: another_user

    get :show, params: { id: another_appeal.id }
    assert_response :not_found
  end

  test 'should create a new appeal' do
    assert_difference("Appeal.for_user(#{@user.id}).count", 1) do
      post :create, params: { appeal: @appeal_attrs }
    end

    assert response_body.dig('data', 'id').present?
    assert_response :success
  end

  test 'should not create if not valid' do
    @appeal_attrs['content'] = nil

    assert_no_difference('Appeal.count') do
      post :create, params: { appeal: @appeal_attrs }
    end

    assert response_body.dig('errors', 'content')&.any?
    assert_response :unprocessable_entity
  end

  test 'user can not create appeal for another user' do
    another_user = create :user
    @appeal_attrs['user_id'] = another_user.id

    assert_difference("Appeal.for_user(#{@user.id}).count", 1) do
      assert_no_difference("Appeal.for_user(#{another_user.id}).count") do
        post :create, params: { appeal: @appeal_attrs }
      end
    end

    assert_response :success
  end
end
