class AddTimestamps < ActiveRecord::Migration[5.0]
  def up
    change_table(:accounts) { |t| t.timestamps default: DateTime.now }
    change_table(:meter_indications) { |t| t.timestamps default: DateTime.now }
    change_table(:meters) { |t| t.timestamps default: DateTime.now }
    change_table(:users) { |t| t.timestamps default: DateTime.now }

    change_column_default(:accounts, :created_at, nil)
    change_column_default(:accounts, :updated_at, nil)

    change_column_default(:meter_indications, :created_at, nil)
    change_column_default(:meter_indications, :updated_at, nil)

    change_column_default(:meters, :created_at, nil)
    change_column_default(:meters, :updated_at, nil)

    change_column_default(:users, :created_at, nil)
    change_column_default(:users, :updated_at, nil)
  end

  def down
    remove_column :accounts, :created_at
    remove_column :accounts, :updated_at

    remove_column :meter_indications, :created_at
    remove_column :meter_indications, :updated_at

    remove_column :meters, :created_at
    remove_column :meters, :updated_at

    remove_column :users, :created_at
    remove_column :users, :updated_at
  end
end
