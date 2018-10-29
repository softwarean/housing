require 'test_helper'

class Web::Admin::AppealsControllerTest < ActionController::TestCase
  setup do
    admin = create :user, :admin
    sign_in admin

    @user = create :user

    @appeal = create :appeal
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @appeal.id }
    assert_response :success
  end

  test 'should update only aasm_state' do
    new_user = create :user

    new_attributes = {
      user_id: new_user.id,
      content: 'new content',
      aasm_state: 'completed'
    }

    put :update, params: { id: @appeal.id, appeal: new_attributes }

    refute @appeal.reload.user_id == new_attributes[:user_id]
    refute @appeal.reload.content == new_attributes[:content]
    assert @appeal.reload.aasm_state == new_attributes[:aasm_state]

    assert_redirected_to admin_appeals_path
  end

  test 'should not update aasm_state' do
    new_attributes = {
      aasm_state: 'completed'
    }

    put :update, params: { id: @appeal.id, appeal: { aasm_state: 'wrong state' } }

    assert_not_equal @appeal.reload.aasm_state, new_attributes[:aasm_state]
    assert_template :edit
  end

  test 'should destroy' do
    assert_difference('Appeal.count', -1) do
      delete :destroy, params: { id: @appeal.id }
    end

    assert_redirected_to admin_appeals_path
  end
end
