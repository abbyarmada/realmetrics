Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.preview_path = "#{Rails.root}/test/mailers/previews"
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = false
  config.assets.digest = true
  config.assets.raise_runtime_errors = true

  config.middleware.insert_after ActionDispatch::Static, Rack::LiveReload
  config.middleware.use(
    Rack::LiveReload,
    min_delay:        1000,
    max_delay:        60_000,
    live_reload_port: 35_729,
    host:             ENV['DEFAULT_URL']
  )
end
