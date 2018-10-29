class CreateMeterIndications < ActiveRecord::Migration[5.0]
  def change
    create_table :meter_indications do |t|
      t.string :meter_uuid
      t.string :meter_description
      t.datetime :transmitted_at
      t.jsonb :data
    end
    add_index :meter_indications, "(data->>'_spec')", name: 'meter_indications_data_spec_index'
  end
end
