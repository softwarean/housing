class CreateReducedIndications < ActiveRecord::Migration[5.0]
  def change
    create_table :reduced_indications do |t|
      t.references :meter, foreign_key: true
      t.date :date, null: false
      t.integer :hour, null: false
      t.integer :last_total, null: false
      t.integer :last_daily
      t.integer :last_nightly

      t.timestamps
    end

    add_index :reduced_indications, :date
    add_index :reduced_indications, [:meter_id, :date, :hour], unique: true
  end
end
