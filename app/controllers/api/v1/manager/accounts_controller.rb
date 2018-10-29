class Api::V1::Manager::AccountsController < Api::V1::Manager::ApplicationController
  include Api::V1::Manager::AccountsControllerDoc

  before_action :apipie_validations

  def index
    accounts = Account.includes(apartment: { house: :street }).page(params[:page]).per(params[:per_page])
    serialized_accounts = serialize_collection(accounts, Api::V1::Manager::AccountSerializer)

    total = Account.count

    render_data(accounts: serialized_accounts, total: total)
  end

  def create
    account = Account.new(account_params)

    if account.save
      render_data(id: account.id)
    else
      unprocessable_entity(account.errors.messages)
    end
  end

  def update
    account = Account.find(params[:id])

    if account.update(account_params)
      render_success
    else
      unprocessable_entity(account.errors.messages)
    end
  end

  def destroy
    account = Account.find(params[:id])
    account.destroy

    render_success
  end

  private

  def account_params
    params.require(:account).permit(:account_number, :apartment_id)
  end
end
