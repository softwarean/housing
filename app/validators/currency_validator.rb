class CurrencyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :currency_scale) unless "#{value}" =~ /\A\d+(?:\.\d{0,2})?\z/
  end
end
