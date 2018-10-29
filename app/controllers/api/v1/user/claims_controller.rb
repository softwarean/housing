class Api::V1::User::ClaimsController < Api::V1::User::ApplicationController
  include Api::V1::User::ClaimsControllerDoc

  before_action :apipie_validations, only: [:create]

  def index
    claims = Claim.for_user(current_user.id).order(created_at: :desc)
    serialized_claims = serialize_collection(claims, Api::V1::User::ClaimSerializer)

    render_data(claims: serialized_claims)
  end

  def create
    claim = Claim.new(claim_params)
    claim.applicant = current_user

    if claim.save
      render_data(id: claim.id)
    else
      unprocessable_entity(claim.errors.messages)
    end
  end

  private

  def claim_params
    params.require(:claim).permit(:service_id, :deadline, :subject, :description)
  end
end
