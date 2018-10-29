require 'test_helper'

class Api::V1::Manager::AppealsControllerTest < ActionController::TestCase
  include IndexPaginationTest
  include DefaultCrudTokenNecessityTest
  include DefaultCrudManagerAuthorizationTest

  setup do
    manager = create :user, :manager
    token = auth_token(manager)

    @appeal = create :appeal
    @appeal_attrs = attributes_for :appeal

    include_content_type_header
    include_auth_header(token)
  end

  test 'should get index' do
    get :index, params: { page: 1, per_page: 25 }
    assert_response :success

    assert response_body.dig('data', 'appeals')&.any?
  end

  test 'should update appeal' do
    new_state = 'completed'
    put :update, params: { id: @appeal.id, appeal: { aasm_state: new_state } }

    assert_equal @appeal.reload.aasm_state, new_state
    assert_response :success
  end

  test 'should not update appeal state if transition is impossible' do
    old_state = @appeal.aasm_state
    new_state = 'imagined_state'
    put :update, params: { id: @appeal.id, appeal: { aasm_state: new_state } }

    assert_equal @appeal.reload.aasm_state, old_state
    assert response_body.dig('errors', 'aasm_state')&.any?
    assert_response :unprocessable_entity
  end

  test 'should destroy appeal' do
    assert_difference('Appeal.count', -1) do
      delete :destroy, params: { id: @appeal.id }
    end

    assert_response :success
  end
end
