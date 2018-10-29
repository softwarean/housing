class Api::V1::Manager::AppealsController < Api::V1::Manager::ApplicationController
  include Api::V1::Manager::AppealsControllerDoc

  before_action :apipie_validations

  def index
    appeals = Appeal.includes(:user).page(params[:page]).per(params[:per_page])
    serialized_appeals = serialize_collection(appeals, Api::V1::Manager::AppealSerializer)

    total = Appeal.count

    render_data(appeals: serialized_appeals, total: total)
  end

  def update
    appeal = Appeal.find(params[:id])

    if appeal.update(appeal_params)
      render_success
    else
      unprocessable_entity(appeal.errors.messages)
    end
  end

  def destroy
    appeal = Appeal.find(params[:id])
    appeal.destroy

    render_success
  end

  private

  def appeal_params
    params.require(:appeal).permit(:aasm_state)
  end
end
