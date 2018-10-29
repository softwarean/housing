class FloatValidator < Apipie::Validator::BaseValidator
  def initialize(param_description, argument)
    super(param_description)
    @type = argument
  end

  def validate(value)
    return false if value.nil?
    !!(value.to_s =~ /^[-+]?\d+\.\d+$/)
  end

  def self.build(param_description, argument, options, block)
    self.new(param_description, argument) if argument == Float
  end

  def description
    "Must be #{@type}. Examples: 10.0, 10.22"
  end
end
