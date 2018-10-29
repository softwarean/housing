class ManagerPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, _record)
    raise Pundit::NotAuthorizedError.new(policy: 'manager') if (user.blank? || !user.role.manager?)
  end

  def method_missing(_name, *_args)
    true
  end
end
