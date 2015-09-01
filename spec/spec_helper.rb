ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'warden'
require 'rspec/rails'
require 'factory_girl_rails'
require 'database_cleaner'
require 'faker'
require 'digest'

Warden.test_mode!

# FactoryGirl.find_definitions

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include Warden::Test::ControllerHelpers, type: :controller
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  def sign_in_member(member)
    member.save if member.new_record?
    warden.set_user member, scope: :diabetic_toolbox__member
  end
end
