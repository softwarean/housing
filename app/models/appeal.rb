class Appeal < ApplicationRecord
  include AASM
  include AppealRepository
  include AasmStateValidationConcern

  belongs_to :user

  aasm whiny_transitions: false do
    state :new, initial: true
    state :completed

    event :handle do
      transitions from: :new, to: :completed
    end
  end

  validates :user_id, :content, presence: true
end
