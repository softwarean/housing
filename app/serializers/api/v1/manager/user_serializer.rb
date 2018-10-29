class Api::V1::Manager::UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :email, :accounts

  def accounts
    object.accounts.map do |account|
      {
        id: account.id,
        account_number: account.account_number
      }
    end
  end
end
