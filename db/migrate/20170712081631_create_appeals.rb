class CreateAppeals < ActiveRecord::Migration[5.0]
  def change
    create_table :appeals do |t|
      t.string :content, null: false
      t.string :aasm_state
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
