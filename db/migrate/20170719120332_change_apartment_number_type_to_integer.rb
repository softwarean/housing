class ChangeApartmentNumberTypeToInteger < ActiveRecord::Migration[5.0]
  def up
    change_column :apartments, :number, 'integer USING CAST(number AS integer)'
  end

  def down
    change_column :apartments, :number, :string
  end
end
