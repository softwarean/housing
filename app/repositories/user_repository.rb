module UserRepository
  extend ActiveSupport::Concern

  included do
    scope :for_manager, -> { where(role: :user) }
  end
end
