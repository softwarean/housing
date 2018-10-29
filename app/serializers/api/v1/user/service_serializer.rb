class Api::V1::User::ServiceSerializer < ActiveModel::Serializer
  attributes :id, :name, :cost
end
