source 'https://rubygems.org'

ruby '2.3.1'

# Backend
gem 'rails', '4.2.6'

# Frontend
gem 'sass-rails', '5.0.4'
gem 'autoprefixer-rails', '6.3.6.2'
gem 'angular-rails-templates', '1.0.0'

# Backend
gem 'uglifier', '3.0.0'
gem 'jbuilder', '2.5.0'
gem 'bcrypt', '3.1.11'
gem 'enumerize', '1.1.1'
gem 'sentry-raven', '1.2.2'

# Databases
gem 'pg', '0.18.4'
gem 'redis', '3.3.0'
gem 'redis-namespace', '1.5.2'
gem 'migration_data', '0.2.1'
gem 'activerecord-import', '0.15.0'

# Stripe payments
gem 'omniauth', '1.3.1'
gem 'omniauth-stripe-connect', '2.9.0'
gem 'stripe', '1.42.0'

# Web server & Environment
gem 'puma', '3.4.0'
gem 'figaro', '1.1.1'

# Jobs
gem 'sinatra', '1.4.7', require: false
gem 'slim', '3.0.7'
gem 'celluloid', '0.17.3'
gem 'sidekiq', '4.1.2'
gem 'sidetiq', '0.7.0'

group :production do
  gem 'rails_12factor', '0.0.3'
end

group :development do
  # Code helpers
  gem 'quiet_assets', '1.1.0'
  gem 'better_errors', '2.1.1'
  gem 'binding_of_caller', '0.7.2'
  gem 'jshint', '1.4.0'

  # Guard
  gem 'guard', '2.14.0'
  gem 'rack-livereload', '0.3.16'
  gem 'guard-livereload', '2.5.2', require: false

  # Procfile management
  gem 'foreman', '0.50.0'
end
