class Api::V1::Manager::ClaimsController < Api::V1::Manager::ApplicationController
  include Api::V1::Manager::ClaimsControllerDoc

  before_action :apipie_validations

  def index
    claims = Claim.includes(:service, :applicant).order(created_at: :desc).page(params[:page]).per(params[:per_page])
    serialized_claims = serialize_collection(claims, Api::V1::Manager::ClaimSerializer)

    total = Claim.count

    render_data(claims: serialized_claims, total: total)
  end

  def create
    claim = Claim.new(create_params)

    if claim.save
      render_data(id: claim.id)
    else
      unprocessable_entity(claim.errors.messages)
    end
  end

  def update
    claim = Claim.find(params[:id])

    if claim.update(update_params)
      render_success
    else
      unprocessable_entity(claim.errors.messages)
    end
  end

  def destroy
    claim = Claim.find(params[:id])
    claim.destroy

    render_success
  end

  private

  def permitted_params
    [:subject, :description, :service_id, :user_id, :deadline]
  end

  def create_params
    params.require(:claim).permit(permitted_params)
  end

  def update_params
    params.require(:claim).permit(permitted_params << :aasm_state)
  end
end
