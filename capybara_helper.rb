require 'rubygems'
require 'rspec/rails'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'

Capybara.configure do |config|
  config.run_server = false
  config.current_driver = :selenium
  config.app_host = 'http://localhost:3000'
  config.default_wait_time = 20
end

RSpec.configure do |config|
  config.include Capybara::DSL
end

describe 'test foo' do
  it 'has foo' do
      visit('/code-reviews')

      expect(page).to have_content 'Code Reviews'
      all('a.show-code-review').each do |code_review_link|
        p code_review_link.text
        p code_review_link[:href]
      end

      first('a.show-code-review').click
      expect(page).to have_content 'foo'
  end
end
