class Web::Admin::ClaimsController < Web::Admin::ApplicationController
  def index
    @q = Claim.includes(:service, :applicant).order(created_at: :desc).ransack(params[:q])
    @claims = @q.result.page(params[:page])
  end

  def new
    @claim = Claim.new
  end

  def edit
    @claim = Claim.find(params[:id]).decorate
  end

  def create
    @claim = Claim.new(claim_params)

    if @claim.save
      redirect_to(admin_claims_path)
    else
      render(:new)
    end
  end

  def update
    @claim = Claim.find(params[:id])
    original_state = @claim.aasm_state

    if @claim.update(claim_params)
      redirect_to(admin_claims_path)
    else
      @claim.aasm_state = original_state
      @claim = @claim.decorate
      render(:edit)
    end
  end

  def destroy
    @claim = Claim.find(params[:id])
    @claim.destroy

    redirect_to admin_claims_path
  end

  private

  def claim_params
    params.require(:claim).permit(:subject, :description, :service_id, :user_id, :deadline, :aasm_state)
  end
end
