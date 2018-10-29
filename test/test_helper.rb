if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start('rails') do
    add_filter 'app/channels/application_cable'
  end
end

if ENV['CI_REPORTER']
  require 'minitest/reporters'
  Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, Minitest::Reporters::JUnitReporter.new]
end

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl_rails'
require 'wrong'

Dir[Rails.root.join('test/support/**/*.rb')].each { |f| require f }

class ActiveSupport::TestCase
  include AuthHelper
  include MetersTestHelper
  include ApiTestHelper
  include Wrong
  include FactoryGirl::Syntax::Methods
  include ActiveJob::TestHelper
end
