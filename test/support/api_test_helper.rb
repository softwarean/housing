module ApiTestHelper
  def auth_token(user)
    JsonWebToken.encode(user_id: user.id)
  end

  def include_auth_header(token)
    @request.headers['Authorization'] = token
  end

  def include_content_type_header
    @request.headers['Content-Type'] = json_mime
  end

  def response_body
    JSON.parse(@response.body)
  end

  def integration_test_headers(token)
    {
      'Authorization': token,
      'Content-Type': json_mime
    }
  end

  def assert_default_actions_responce(response_status)
    action_methods = @controller.action_methods

    if action_methods.include?('index')
      get :index
      assert_response response_status
    end

    if action_methods.include?('create')
      post :create
      assert_response response_status
    end

    if action_methods.include?('update')
      put :update, params: { id: 1 }
      assert_response response_status
    end

    if action_methods.include?('destroy')
      delete :destroy, params: { id: 1 }
      assert_response response_status
    end
  end

  def not_managers
    user = create :user
    admin = create :user, :admin

    [user, admin]
  end

  private

  def json_mime
    Mime[:json].to_s
  end
end
