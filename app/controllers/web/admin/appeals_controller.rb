class Web::Admin::AppealsController < Web::Admin::ApplicationController
  def index
    @q = Appeal.includes(:user).order(created_at: :desc).ransack(params[:q])
    @appeals = @q.result.page(params[:page])
  end

  def edit
    @appeal = Appeal.find(params[:id]).decorate
  end

  def update
    @appeal = Appeal.find(params[:id])
    original_state = @appeal.aasm_state

    if @appeal.update(appeal_params)
      redirect_to(admin_appeals_path)
    else
      @appeal.aasm_state = original_state
      @appeal = @appeal.decorate
      render(:edit)
    end
  end

  def destroy
    @appeal = Appeal.find(params[:id])
    @appeal.destroy

    redirect_to admin_appeals_path
  end

  private

  def appeal_params
    params.require(:appeal).permit(:aasm_state)
  end
end
