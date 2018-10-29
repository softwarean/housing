class Api::V1::Manager::AccountSerializer < ActiveModel::Serializer
  attributes :id, :account_number, :street, :house, :apartment

  def street
    object.apartment.house.street.name
  end

  def house
    object.apartment.house.house_number
  end

  def apartment
    object.apartment.number
  end
end
