class Web::Admin::AccountsController < Web::Admin::ApplicationController
  def index
    @q = Account.includes(apartment: { house: :street }).ransack(params[:q])
    @accounts = @q.result.page(params[:page])
  end

  def new
    @account = Account.new
  end

  def edit
    @account = Account.find(params[:id])
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to(admin_accounts_path)
    else
      render(:new)
    end
  end

  def update
    @account = Account.find(params[:id])

    if @account.update(account_params)
      redirect_to(admin_accounts_path)
    else
      render(:edit)
    end
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    redirect_to admin_accounts_path
  end

  private

  def account_params
    params.require(:account).permit(:account_number, :apartment_id)
  end
end
