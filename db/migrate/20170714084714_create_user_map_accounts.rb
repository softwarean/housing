class CreateUserMapAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :user_map_accounts do |t|
      t.references :user, foreign_key: true
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
