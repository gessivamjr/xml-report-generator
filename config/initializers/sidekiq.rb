Sidekiq.configure_server do |config|
  config.logger = Sidekiq::Logger.new(Rails.root.join('log/sidekiq.log'))
  config.logger.formatter = Sidekiq::Logger::Formatters::Pretty.new
end
