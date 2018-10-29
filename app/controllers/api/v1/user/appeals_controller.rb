class Api::V1::User::AppealsController < Api::V1::User::ApplicationController
  include Api::V1::User::AppealsControllerDoc

  def index
    appeals = Appeal.for_user(current_user.id).order(created_at: :desc)
    serialized_appeals = serialize_collection(appeals, Api::V1::User::AppealSerializer)

    render_data(appeals: serialized_appeals)
  end

  def show
    appeal = Appeal.for_user(current_user.id).find(params[:id])
    serialized_appeal = serialize_model(appeal, Api::V1::User::AppealSerializer)

    render_data(appeal: serialized_appeal)
  end

  def create
    appeal = Appeal.new(appeal_params)
    appeal.user = current_user

    if appeal.save
      render_data(id: appeal.id)
    else
      unprocessable_entity(appeal.errors.messages)
    end
  end

  private

  def appeal_params
    params.require(:appeal).permit(:content)
  end
end
