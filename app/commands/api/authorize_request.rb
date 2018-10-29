class Api::AuthorizeRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    load_user
  end

  private

  attr_reader :headers

  def load_user
    user = User.find(decoded_auth_token[:user_id]) if decoded_auth_token

    return user if user.present?

    errors.add(:token, I18n.t('api.errors.invalid_token'))

    nil
  end

  def decoded_auth_token
    JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    authorization_header = headers['Authorization']

    return authorization_header.split(' ').last if authorization_header.present?

    errors.add(:token, I18n.t('api.errors.missing_token'))

    nil
  end
end
