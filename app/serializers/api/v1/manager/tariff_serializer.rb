class Api::V1::Manager::TariffSerializer < ActiveModel::Serializer
  attributes :id, :name, :kind, :unit_of_measure, :value

  def kind
    object.kind && [object.kind.text, object.kind]
  end
end
