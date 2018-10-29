require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'presence validators' do
    user = User.new
    refute user.valid?
    assert_equal([:name, :phone, :email, :password], user.errors.keys)
  end

  test 'email_validator' do
    user = create :user

    assert user.valid?

    user.email = 'notvalidemail'

    refute user.valid?
    assert_equal([:email], user.errors.keys)
  end

  test 'email uniqueness' do
    user1 = create :user
    user2 = create :user
    email = 'test@example.com'

    user1.email = email
    user2.email = email

    user1.save!

    refute user2.valid?
    assert_equal([:email], user2.errors.keys)
  end
end
