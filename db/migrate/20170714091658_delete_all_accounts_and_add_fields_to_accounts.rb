class DeleteAllAccountsAndAddFieldsToAccounts < ActiveRecord::Migration[5.0]
  class Account < ActiveRecord::Base;end

  def change
    Account.delete_all

    add_column :accounts, :apartment_id, :integer, null: false

    add_index :accounts, :apartment_id
  end
end
