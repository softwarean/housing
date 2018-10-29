class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, _record)
    raise Pundit::NotAuthorizedError.new(policy: 'user') if user.blank?
  end

  def method_missing(_name, *_args)
    true
  end
end
