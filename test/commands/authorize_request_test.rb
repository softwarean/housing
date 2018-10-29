require 'test_helper'

class AuthorizeRequestTest < ActiveSupport::TestCase
  setup do
    @user = create :user

    credentials = HashWithIndifferentAccess.new(
      email: @user.email,
      password: @user.password
    )

    @token = Api::AuthenticateUser.call(credentials).result
  end

  test 'should authorize request' do
    command = Api::AuthorizeRequest.call headers(@token)

    assert command.success?

    current_user = command.result
    assert current_user.present?
    assert current_user.id == @user.id
  end

  test 'should fail on auth header absence' do
    command = Api::AuthorizeRequest.call

    assert command.failure?
    assert_nil command.result
  end

  test 'should fail on auth header emptiness' do
    command = Api::AuthorizeRequest.call headers('')

    assert command.failure?
    assert_nil command.result
  end

  test 'should fail on wrong auth header' do
    command = Api::AuthorizeRequest.call headers('invalid_token')

    assert command.failure?
    assert_nil command.result
  end

  private

  def headers(token)
    HashWithIndifferentAccess.new('Authorization': token)
  end
end
