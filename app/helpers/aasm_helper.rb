module AasmHelper
  def possible_states(model)
    next_possible_states = model.aasm.states(permitted: true).map(&:for_select)
    next_possible_states.unshift(current_state_for_select(model))
  end

  private

  def current_state_for_select(model)
    current_state = model.aasm.states.find { |s| s.name == model.aasm.current_state }
    current_state.for_select
  end
end
