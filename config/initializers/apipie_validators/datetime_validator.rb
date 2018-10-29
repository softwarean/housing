class DateTimeValidator < Apipie::Validator::BaseValidator
  def initialize(param_description, argument)
    super(param_description)
    @type = argument
  end

  def validate(value)
    return false if value.nil?
    !!(value.to_s =~ /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.{0,1}\d*\+\d{2}:\d{2}$/)
  end

  def self.build(param_description, argument, options, block)
    self.new(param_description, argument) if argument == DateTime
  end

  def description
    "Must be #{@type}. Formats: 2017-08-18T13:39:44+04:00, 2017-08-20T09:29:49.958+00:00"
  end
end
