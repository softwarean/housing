class Api::V1::User::AccountSerializer < ActiveModel::Serializer
  attributes :users

  def users
    object.users.map do |user|
      {
        name: user.name,
        phone: user.phone
      }
    end
  end
end
