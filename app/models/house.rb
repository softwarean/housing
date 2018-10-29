class House < ApplicationRecord
  has_many :apartments
  has_many :meters, dependent: :destroy

  belongs_to :street

  validates_uniqueness_of :street_id, scope: :house_number
  validates :street_id, :house_number, presence: true

  before_destroy :ensure_no_apartments, prepend: true

  private

  def ensure_no_apartments
    if apartments.any?
      errors.add(:apartments, :presence)
      throw(:abort)
    end
  end
end
