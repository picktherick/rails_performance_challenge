ENV['RAILS_ENV'] ||= 'test'

# Suprimir warnings de BigDecimal deprecation do ActiveRecord 4.2
$VERBOSE = nil

require File.expand_path('../../config/environment', __FILE__)

# Restaurar warnings após carregar o Rails
$VERBOSE = false

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'database_cleaner'
require 'factory_bot_rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Database Cleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
