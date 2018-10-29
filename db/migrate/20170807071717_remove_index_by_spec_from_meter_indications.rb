class RemoveIndexBySpecFromMeterIndications < ActiveRecord::Migration[5.0]
  def change
    remove_index :meter_indications, name: 'meter_indications_data_spec_index'
  end
end
