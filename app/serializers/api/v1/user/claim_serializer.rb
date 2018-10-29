class Api::V1::User::ClaimSerializer < ActiveModel::Serializer
  attributes :id, :service, :cost, :state, :deadline, :created_at

  def service
    object.service.name
  end

  def cost
    object.service.cost
  end

  def state
    object.aasm_state
  end
end
