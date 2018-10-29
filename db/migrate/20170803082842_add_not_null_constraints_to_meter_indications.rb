class AddNotNullConstraintsToMeterIndications < ActiveRecord::Migration[5.0]
  def change
    change_column_null :meter_indications, :meter_uuid, false
    change_column_null :meter_indications, :transmitted_at, false
  end
end
