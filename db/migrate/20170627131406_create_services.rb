class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.decimal :cost, null: false

      t.timestamps
    end
  end
end
