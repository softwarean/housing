class DropIsReducedFromMeterIndications < ActiveRecord::Migration[5.0]
  def change
    remove_column :meter_indications, :is_reduced, :boolean, null: false, default: false
  end
end
