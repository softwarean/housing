class CreateHouses < ActiveRecord::Migration[5.0]
  def change
    create_table :houses do |t|
      t.references :street, foreign_key: true, null: false
      t.string :number, null: false

      t.timestamps
    end
  end
end
