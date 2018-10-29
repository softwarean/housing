module AasmStatesConcern
  extend ActiveSupport::Concern

  def state
    current_state = object.aasm.states.find { |s| s.name == object.aasm.current_state }
    current_state.for_select
  end

  def possible_states
    object.aasm.states(permitted: true).map(&:for_select)
  end
end
