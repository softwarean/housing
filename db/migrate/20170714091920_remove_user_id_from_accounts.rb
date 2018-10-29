class RemoveUserIdFromAccounts < ActiveRecord::Migration[5.0]
  def up
    remove_column :accounts, :user_id, :integer
  end

  def down
    add_column :accounts, :user_id, :integer
    add_index :accounts, :user_id
    add_foreign_key :accounts, :users
  end
end
