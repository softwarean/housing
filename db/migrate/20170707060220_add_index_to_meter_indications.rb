class AddIndexToMeterIndications < ActiveRecord::Migration[5.0]
  def change
    add_index :meter_indications, :transmitted_at
    add_index :meter_indications, :created_at
    add_index :meter_indications, :meter_uuid
  end
end
