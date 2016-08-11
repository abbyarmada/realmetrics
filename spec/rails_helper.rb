ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

dir = 'tmp/coverage'

SimpleCov.coverage_dir dir
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new
SimpleCov.start 'rails'

Dir[Rails.root.join('spec/support/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :active_record
    with.library :active_model
    with.library :action_controller
  end
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.include FactoryGirl::Syntax::Methods, type: :model
  config.extend ControllersMacros, type: :controller

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation, reset_ids: true)
    FactoryGirl.lint
  end

  config.around(:each) do |test|
    DatabaseCleaner.cleaning do
      test.run
    end
  end
end
