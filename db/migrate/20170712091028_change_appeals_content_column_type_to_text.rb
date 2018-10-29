class ChangeAppealsContentColumnTypeToText < ActiveRecord::Migration[5.0]
  def up
    change_column :appeals, :content, :text
  end

  def down
    change_column :appeals, :content, :string
  end
end
