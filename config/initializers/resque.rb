unless Rails.env == 'test'
  Resque.logger.level = Logger::DEBUG

  Resque::Scheduler.dynamic = true
  Resque.schedule = YAML.load_file('resque_schedule.yml')
end
