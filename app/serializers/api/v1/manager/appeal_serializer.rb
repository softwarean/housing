class Api::V1::Manager::AppealSerializer < ActiveModel::Serializer
  include AasmStatesConcern

  attributes :id, :created_at, :content, :user, :user_phone, :state, :possible_states

  def user
    object.user.name
  end

  def user_phone
    object.user.phone
  end
end
