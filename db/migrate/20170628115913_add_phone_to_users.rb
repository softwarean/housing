class AddPhoneToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :phone, :string, null: false, default: ''
    change_column_default :users, :phone, from: '', to: nil
  end
end
