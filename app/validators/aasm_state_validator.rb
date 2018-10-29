class AasmStateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    previous_state = record.aasm_state_was
    stub = record.class.new(aasm_state: previous_state)
    record.errors.add(attribute, :forbidden_transition) unless permitted_states(stub).include?(value.to_sym)
  end

  private

  def permitted_states(record)
    [record.aasm.current_state] + record.aasm.states(permitted: true).map(&:name)
  end
end
