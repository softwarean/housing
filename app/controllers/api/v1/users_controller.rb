class Api::V1::UsersController < Api::V1::ApplicationController
  include Api::V1::UsersControllerDoc

  skip_before_action :authorize_request

  def create
    user = UserRegisterType.new(user_params)

    if user.save
      render_success
    else
      unprocessable_entity(user.errors.messages)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation)
  end
end
