class Api::V1::User::ProfilesController < Api::V1::User::ApplicationController
  include Api::V1::User::ProfilesControllerDoc

  def show
    serialized_user = serialize_model(current_user, Api::V1::User::ProfileSerializer)

    render_data(profile: serialized_user)
  end

  def update
    user = current_user.becomes(ProfileUpdateType)

    if user.update(user_params)
      render_success
    else
      unprocessable_entity(user.errors.messages)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :phone, :password, :password_confirmation)
  end
end
