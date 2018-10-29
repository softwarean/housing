class Street < ApplicationRecord
  has_many :houses

  validates :name, presence: true

  before_destroy :ensure_no_houses, prepend: true

  private

  def ensure_no_houses
    if houses.any?
      errors.add(:houses, :presence)
      throw(:abort)
    end
  end
end
