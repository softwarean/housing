class UserRegisterType < User
  validates :password, :password_confirmation, presence: true
  validates_confirmation_of :password
end
