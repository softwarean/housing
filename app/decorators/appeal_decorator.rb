class AppealDecorator < ApplicationDecorator
  include AasmHelper

  delegate_all

  def permitted_states
    possible_states(model)
  end
end
