class User < ApplicationRecord
  extend Enumerize
  include UserRepository

  attr_accessor :skip_phone_validation

  has_many :user_map_accounts, dependent: :destroy
  has_many :accounts, through: :user_map_accounts
  has_many :claims

  accepts_nested_attributes_for :user_map_accounts, reject_if: :all_blank, allow_destroy: true

  validates :name, :phone, :role, :email, presence: true
  validates :phone, phone: true, unless: :skip_phone_validation
  validates :email, uniqueness: true
  validates :email, email: true
  validates :password, password: true

  has_secure_password

  enumerize :role, in: [:admin, :user, :manager], default: :user
end
