ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails/capybara'
require 'mocha/mini_test'
require 'capybara/poltergeist'
require 'shoulda'
require 'shoulda-matchers'

Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 5

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def login_user(user_id)
    user = users(user_id)
    session[:user_id] = user.id
  end

  def logger
    Rails.logger
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end

# ActionController::Base.asset_host = 'http://catalog.192.168.222.225.xip.io'
# Searchkick.disable_callbacks

require 'public_activity/testing'
PublicActivity.enabled = false
