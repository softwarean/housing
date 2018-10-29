class AddHouseIdToMeters < ActiveRecord::Migration[5.0]
  def change
    add_column :meters, :house_id, :integer
    add_index :meters, :house_id
    add_foreign_key :meters, :houses
  end
end
