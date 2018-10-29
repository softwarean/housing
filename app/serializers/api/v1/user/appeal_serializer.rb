class Api::V1::User::AppealSerializer < ActiveModel::Serializer
  attributes :id, :content, :state, :created_at

  def state
    object.aasm_state
  end
end
