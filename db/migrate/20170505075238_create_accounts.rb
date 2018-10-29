class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.references :user, foreign_key: true
      t.string :account_number, null: false
    end
    add_index :accounts, :account_number, unique: true
  end
end
