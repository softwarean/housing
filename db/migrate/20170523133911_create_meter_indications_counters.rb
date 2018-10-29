class CreateMeterIndicationsCounters < ActiveRecord::Migration[5.0]
  def change
    create_table :meter_indications_counters do |t|
      t.references :meter, foreign_key: true
      t.integer :value
      t.string :kind, null: false
      t.string :diff_kind, null: false
      t.integer :month, null: false

      t.timestamps
    end
    add_index :meter_indications_counters, [:meter_id, :kind, :diff_kind, :month], unique: true,
      name: 'unique_meter_id_and_kind_and_diff_kind_and_month'
  end
end
