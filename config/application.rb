require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(*Rails.groups)

module RealMetrics
  class Application < Rails::Application
    config.generators do |g|
      g.view_specs false
      g.helper_specs false
      g.model_specs false
      g.test_framework nil
    end

    # Use Sidekiq to handle mail deliveries
    config.active_job.queue_adapter = :sidekiq

    # Use HTTP compression
    config.middleware.use Rack::Deflater

    # Enable subdirectories in models
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '**')]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '**', '**')]

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # SMTP settings
    config.action_mailer.smtp_settings = {
      address: ENV['SMTP_ADDRESS'],
      port: ENV['SMTP_PORT'],
      domain: ENV['SMTP_DOMAIN'],
      authentication: 'plain',
      enable_starttls_auto: true,
      user_name: ENV['SMTP_USERNAME'],
      password: ENV['SMTP_PASSWORD']
    }

    # ActionMailer Config
    config.action_mailer.default_url_options = { host: ENV['DEFAULT_URL'] }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
  end
end
