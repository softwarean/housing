class Api::V1::Manager::UsersController < Api::V1::Manager::ApplicationController
  include Api::V1::Manager::UsersControllerDoc

  before_action :apipie_validations

  def index
    users = User.for_manager.order(:name).page(params[:page]).per(params[:per_page])
    serialized_users = serialize_collection(users, Api::V1::Manager::UserSerializer)

    total = users.count

    render_data(users: serialized_users, total: total)
  end

  def create
    user = ManagerAccessUserType.new(user_params)

    if user.save(user_params)
      render_data(id: user.id)
    else
      unprocessable_entity(user.errors.messages)
    end
  end

  def update
    user = ManagerAccessUserType.for_manager.find(params[:id])

    if user.update(user_params)
      render_success
    else
      unprocessable_entity(user.errors.messages)
    end
  end

  def destroy
    user = ManagerAccessUserType.for_manager.find(params[:id])
    user.destroy

    render_success
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :email, :password, account_ids: [])
  end
end
