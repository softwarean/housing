class Api::V1::Manager::HouseSerializer < ActiveModel::Serializer
  attributes :id, :number

  def number
    object.house_number
  end
end
