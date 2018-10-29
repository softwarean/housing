class Api::V1::User::AccountsController < Api::V1::User::ApplicationController
  include Api::V1::User::AccountsControllerDoc

  def show
    account = current_user.accounts.first
    serialized_account = serialize_model(account, Api::V1::User::AccountSerializer)

    render_data(account: serialized_account)
  end
end
