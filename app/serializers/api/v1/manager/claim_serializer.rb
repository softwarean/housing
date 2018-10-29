class Api::V1::Manager::ClaimSerializer < ActiveModel::Serializer
  include AasmStatesConcern

  attributes :id, :subject, :description, :service, :applicant, :deadline, :state, :possible_states, :created_at

  def service
    object.service.name
  end

  def applicant
    object.applicant.name
  end
end
