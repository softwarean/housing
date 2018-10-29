class WebSignInType < ActiveType::Object
  attribute :email, :string
  attribute :password, :string

  validates :email, :password, presence: true
  validate :check_authentication, if: :email

  def user
    User.where(role: 'admin').find_by(email: email.mb_chars.downcase)
  end

  private

  def check_authentication
    unless user.try(:authenticate, password)
      errors.add(:password, :authentication_failed)
    end
  end
end
