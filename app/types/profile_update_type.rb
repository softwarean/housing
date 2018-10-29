class ProfileUpdateType < User
  validates :password_confirmation, presence: true, if: :password_present?
  validates_confirmation_of :password, if: :password_present?

  private

  def password_present?
    self.password.present?
  end
end
