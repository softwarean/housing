class RenameNumberToHouseNumberInHouses < ActiveRecord::Migration[5.0]
  def change
    rename_column :houses, :number, :house_number
  end
end
