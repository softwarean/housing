class ChangeClaimsDescriptionColumnTypeToText < ActiveRecord::Migration[5.0]
  def up
    change_column :claims, :description, :text
  end

  def down
    change_column :claims, :description, :string
  end
end
