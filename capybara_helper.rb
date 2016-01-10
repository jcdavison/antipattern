require 'rubygems'
require 'rspec/rails'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'

Capybara.run_server = false
Capybara.javascript_driver = :selenium
Capybara.server_port = 8200
Capybara.default_wait_time = 7
Capybara.app_host = 'http://localhost:3000'


RSpec.configure do |config|
  config.include Capybara::DSL
end

describe 'foo', js: true do
  it 'foo' do
    visit('/code-reviews')
    all('span.code-review-context').select {|code_review|  p code_review.text }
  end
end
