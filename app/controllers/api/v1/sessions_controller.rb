class Api::V1::SessionsController < Api::V1::ApplicationController
  include Api::V1::SessionsControllerDoc

  skip_before_action :authorize_request

  def create
    command = Api::AuthenticateUser.call(credentials)

    if command.success?
      render_data(auth_token: command.result)
    else
      access_forbidden
    end
  end

  private

  def credentials
    {
      email: params[:email],
      password: params[:password]
    }
  end
end
