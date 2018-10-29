require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.i18n.default_locale = :ru
    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')
    config.middleware.use I18n::JS::Middleware
    config.action_controller.include_all_helpers = false
  end
end
