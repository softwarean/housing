class NotPastValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :date_in_past) if value < DateTime.current
  end
end
