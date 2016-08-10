require 'sidekiq'
require 'sidekiq/web'

Sidetiq.configure do |config|
  config.utc = true
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], namespace: 'realmetrics' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], namespace: 'realmetrics' }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['ADMIN_USERNAME'], ENV['ADMIN_PASSWORD']]
end
