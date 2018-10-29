require 'test_helper'

class AuthenticateUserTest < ActiveSupport::TestCase
  setup do
    @user = create :user
  end

  test 'should return token' do
    credentials = HashWithIndifferentAccess.new(
      email: @user.email,
      password: @user.password
    )

    command = Api::AuthenticateUser.call(credentials)

    assert command.success?
    assert command.result.present?
  end

  test 'should fail on wrong password' do
    credentials = HashWithIndifferentAccess.new(
      email: @user.email,
      password: 'invalid password'
    )

    command = Api::AuthenticateUser.call(credentials)

    assert command.failure?
    assert_nil command.result
  end

  test 'should fail on wrong email' do
    credentials = HashWithIndifferentAccess.new(
      email: 'invalid email',
      password: @user.password
    )

    command = Api::AuthenticateUser.call(credentials)

    assert command.failure?
    assert_nil command.result
  end
end
