class Api::V1::User::TariffSerializer < ActiveModel::Serializer
  attributes :id, :name, :unit_of_measure, :value
end
