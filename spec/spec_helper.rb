ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'warden'
require 'rspec/rails'
require 'shoulda-matchers'
require 'capybara/rails'
require 'capybara/rspec'
require 'database_cleaner'
require 'factory_girl_rails'
require 'faker'
require 'digest'
require 'show_me_the_cookies'

Warden.test_mode!

# FactoryGirl.find_definitions

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.include Warden::Test::ControllerHelpers, type: :controller
  config.include ShowMeTheCookies,                type: :feature

  config.include DiabeticToolbox::Engine.routes.url_helpers
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false

  config.after(:each, :type => :request) do
    DatabaseCleaner.clean       # Truncate the database
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end

  def sign_in_member(member)
    member.save if member.new_record?
    warden.set_user member, scope: :diabetic_toolbox__member
  end

  def random_string(length)
    (0...length).map { ('a'..'z').to_a[rand(26)] }.join
  end
end
