module AasmStateValidationConcern
  extend ActiveSupport::Concern

  included do
    validates :aasm_state, aasm_state: { on: :update, if: :state_changed? }
  end

  def state_changed?
    self.aasm_state_changed?
  end
end
