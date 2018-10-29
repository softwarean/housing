class Account < ApplicationRecord
  has_many :user_map_accounts, dependent: :destroy
  has_many :users, through: :user_map_accounts

  belongs_to :apartment

  validates :apartment_id, :account_number, presence: true
  validates :account_number, uniqueness: true
end
