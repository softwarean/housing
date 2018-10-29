class RenameMeterColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :meters, :meter_number, :number
    rename_column :meters, :meter_type, :kind
  end
end
