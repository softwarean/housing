class AddKindToTariffs < ActiveRecord::Migration[5.0]
  def change
    add_column :tariffs, :kind, :string
  end
end
