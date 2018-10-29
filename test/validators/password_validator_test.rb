require 'test_helper'

class PasswordValidatable
  include ActiveModel::Validations
  attr_accessor :password

  validates :password, password: true
end

class PasswordValidatorTest < ActiveSupport::TestCase
  setup do
    @validatable = PasswordValidatable.new
    @invalid_passwords = [' ', ' password', 'pass word', 'password ']
  end

  test 'should invalidate password' do
    @invalid_passwords.each do |password|
      @validatable.password = password
      refute @validatable.valid?
    end
  end

  test 'should validate password' do
    @validatable.password = 'password'
    assert @validatable.valid?
  end
end
