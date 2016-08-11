source 'https://rubygems.org'

ruby '2.3.1'

# Backend
gem 'rails', '4.2.6'

# Frontend
gem 'sass-rails', '5.0.4'
gem 'autoprefixer-rails', '6.4.0.1'
gem 'angular-rails-templates', '1.0.1'

# Backend
gem 'uglifier', '3.0.1'
gem 'jbuilder', '2.6.0'
gem 'bcrypt', '3.1.11'
gem 'enumerize', '2.0.0'
gem 'sentry-raven', '1.2.2'

# Databases
gem 'pg', '0.18.4'
gem 'redis', '3.3.1'
gem 'redis-namespace', '1.5.2'
gem 'activerecord-import', '0.15.0'

# Stripe payments
gem 'omniauth', '1.3.1'
gem 'omniauth-stripe-connect', '2.9.0'
gem 'stripe', '1.49.0'

# Web server & Environment
gem 'puma', '3.6.0'
gem 'figaro', '1.1.1'

# Jobs
gem 'sinatra', '1.4.7', require: false
gem 'sidekiq', '4.1.4'

group :production do
  gem 'rails_12factor', '0.0.3'
end

group :development do
  # Code helpers
  gem 'better_errors', '2.1.1'
  gem 'binding_of_caller', '0.7.2'
  gem 'jshint', '1.4.0'

  # Guard
  gem 'guard', '2.14.0'
  gem 'rack-livereload', '0.3.16'
  gem 'guard-livereload', '2.5.2', require: false

  # Procfile management
  gem 'foreman', '0.82.0'
end

group :test, :development do
  gem 'rspec-rails', '3.5.1'
  gem 'factory_girl_rails', '4.7.0'
end

group :test do
  gem 'database_cleaner', '1.5.3'
  gem 'simplecov', '0.12.0'
  gem 'shoulda-matchers', '3.1.1'
  gem 'shoulda-callback-matchers', '1.1.4'
  gem 'json_spec', '1.1.4'
  gem 'codeclimate-test-reporter', require: nil
end
