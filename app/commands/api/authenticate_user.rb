class Api::AuthenticateUser
  prepend SimpleCommand

  def initialize(credentials)
    @email = credentials[:email]
    @password = credentials[:password]
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_reader :email, :password

  def user
    user = User.find_by_email(email.mb_chars.downcase)

    return user if user&.authenticate(password)

    errors.add(:credentials, I18n.t('api.errors.invalid_credentials'))

    nil
  end
end
