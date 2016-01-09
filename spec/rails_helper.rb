ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'

require File.expand_path("../../config/environment", __FILE__)
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
require 'rspec/rails'
require 'capybara/rspec'
Capybara.run_server = false
Capybara.javascript_driver = :selenium
Capybara.server_port = 8200
Capybara.default_wait_time = 7
Capybara.app_host = 'http://localhost:3000'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include Capybara::DSL
  config.include FeaturesHelper, :type => :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!
end
