class Apartment < ApplicationRecord
  include ApartmentRepository

  belongs_to :house
  has_one :account

  validates_uniqueness_of :house_id, scope: :number
  validates :house_id, :number, presence: true

  before_destroy :ensure_no_account, prepend: true

  private

  def ensure_no_account
    if account.present?
      errors.add(:account, :presence)
      throw(:abort)
    end
  end
end
