class Api::V1::Manager::ServiceSerializer < ActiveModel::Serializer
  attributes :id, :name, :cost
end
