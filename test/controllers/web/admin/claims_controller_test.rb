require 'test_helper'

class Web::Admin::ClaimsControllerTest < ActionController::TestCase
  setup do
    admin = create :user, :admin
    sign_in admin

    @user = create :user
    @manager = create :user, :manager

    @service = create :service

    @claim = create :claim
    @claim_attrs = attributes_for :claim
    @claim_attrs[:user_id] = @user.id
    @claim_attrs[:service_id] = @service.id
  end

  test 'admin should get index' do
    get :index
    assert_response :success
  end

  test 'should not get index' do
    sign_in @user

    get :index
    assert_redirected_to login_path

    sign_in @manager

    get :index
    assert_redirected_to login_path
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create' do
    assert_difference('Claim.count', 1) do
      post :create, params: { claim: @claim_attrs }
    end
    assert_redirected_to admin_claims_path
  end

  test 'create with wrong params rerenders new' do
    @claim_attrs[:deadline] = DateTime.current - 1.day

    post :create, params: { claim: @claim_attrs }
    assert_template :new
  end

  test 'should get edit' do
    get :edit, params: { id: @claim.id }
    assert_response :success
  end

  test 'should update' do
    new_subject = 'new subject'
    put :update, params: { id: @claim.id, claim: { subject: new_subject } }
    assert_equal @claim.reload.subject, new_subject
    assert_response :redirect
  end

  test 'update with wrong params rerenders edit' do
    @claim_attrs[:deadline] = DateTime.current - 1.day

    put :update, params: { id: @claim.id, claim: @claim_attrs }
    assert_template :edit
  end

  test 'should destroy' do
    assert_difference('Claim.count', -1) do
      delete :destroy, params: { id: @claim.id }
    end

    assert_redirected_to admin_claims_path
  end
end
