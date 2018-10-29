class CreateClaims < ActiveRecord::Migration[5.0]
  def change
    create_table :claims do |t|
      t.string :subject
      t.string :description
      t.references :service, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.datetime :deadline
      t.string :aasm_state

      t.timestamps
    end
  end
end
