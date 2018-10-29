class AdminPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, _record)
    raise Pundit::NotAuthorizedError.new(policy: 'admin') if (user.blank? || !user.role.admin?)
  end

  def method_missing(_name, *_args)
    true
  end
end
