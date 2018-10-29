class CreateApartments < ActiveRecord::Migration[5.0]
  def change
    create_table :apartments do |t|
      t.references :house, foreign_key: true, null: false
      t.string :number, null: false
      t.decimal :total_area

      t.timestamps
    end
  end
end
