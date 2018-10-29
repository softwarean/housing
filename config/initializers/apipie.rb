Apipie.configure do |config|
  config.app_name                = "App"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  config.namespaced_resources = true
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
  config.validate = :explicitly
end
