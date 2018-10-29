class AddAddressIndices < ActiveRecord::Migration[5.0]
  def change
    add_index :houses, [:street_id, :number], unique: true
    add_index :apartments, [:house_id, :number], unique: true
  end
end
