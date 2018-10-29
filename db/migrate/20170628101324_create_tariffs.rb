class CreateTariffs < ActiveRecord::Migration[5.0]
  def change
    create_table :tariffs do |t|
      t.string :name, null: false
      t.string :unit_of_measure, null: false
      t.decimal :value, null: false

      t.timestamps
    end
  end
end
