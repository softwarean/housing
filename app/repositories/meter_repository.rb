module MeterRepository
  extend ActiveSupport::Concern

  included do
    scope :without_common_house_meters, -> { where.not(account_number: nil) }
    scope :common_house_meters, -> { where(account_number: nil) }
    scope :for_account, ->(account_number) { where(account_number: account_number) }
  end
end
