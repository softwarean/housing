class CreateMeters < ActiveRecord::Migration[5.0]
  def change
    create_table :meters do |t|
      t.string :uuid, null: false
      t.string :description
      t.string :meter_number
      t.string :meter_type, null: false
      t.string :account_number
      t.string :street
      t.string :house
      t.string :apartment
      t.string :floor
    end
    add_index :meters, :uuid, unique: true
  end
end
