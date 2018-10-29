class PasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :space) if value =~ /\s+/
  end
end
