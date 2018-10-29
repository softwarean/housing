class Claim < ApplicationRecord
  include AASM
  include ClaimRepository
  include AasmStateValidationConcern

  belongs_to :applicant, class_name: 'User', foreign_key: :user_id
  belongs_to :service

  aasm whiny_transitions: false do
    state :new, initial: true
    state :in_processing
    state :rejected
    state :completed

    event :take_to_work do
      transitions from: :new, to: :in_processing
    end

    event :reject do
      transitions from: [:new, :in_processing], to: :rejected
    end

    event :complete do
      transitions from: :in_processing, to: :completed
    end
  end

  validates :user_id, :service_id, :deadline, presence: true
  validates :deadline, not_past: true, allow_blank: true
end
