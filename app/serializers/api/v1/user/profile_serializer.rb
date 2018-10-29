class Api::V1::User::ProfileSerializer < ActiveModel::Serializer
  attributes :name, :email, :phone, :role

  attribute :address, if: :has_accounts?
  attribute :account_number, if: :has_accounts?

  def address
    account = load_account

    apartment = account.apartment.number
    house = account.apartment.house.house_number
    street = account.apartment.house.street.name

    "#{street}, #{house}, #{I18n.translate('apartment')} #{apartment}"
  end

  def account_number
    account = load_account

    account.account_number
  end

  def has_accounts?
    object.accounts.any?
  end

  private

  def load_account
    object.accounts.first
  end
end
