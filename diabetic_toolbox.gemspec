$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "diabetic_toolbox/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'diabetic-toolbox'
  s.version     = DiabeticToolbox::VERSION
  s.authors     = ['RPC']
  s.email       = ['rpc@bewitching.me']
  s.homepage    = 'https://github.com/bewitchingme/diabetic_toolbox'
  s.summary     = 'Tools to improve management of diabetes.'
  s.description = 'A collection of tools to allow for the management of diabetes including meal planning, glucometer recording and reporting, and some community features.'
  s.license     = 'MIT'
  s.required_ruby_version = '~> 2.2.2'
  
  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_runtime_dependency 'rails', '~> 4.2.3'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'warden-rspec-rails'
  s.add_development_dependency 'rdoc-generator-fivefish'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'show_me_the_cookies'
  s.add_dependency 'warden', '~> 1.2.3'
  s.add_dependency 'haml', '~> 4.0.6'
  s.add_dependency 'haml-rails', '~> 0.9.0'
  s.add_dependency 'prawn-rails'
  s.add_dependency 'kaminari', '~> 0.16.3'
  s.add_dependency 'chartkick', '~> 1.3.2'
  s.add_dependency 'paperclip', '~> 4.3.0'
  s.add_dependency 'groupdate', '~> 2.4.0'
  s.add_dependency 'cancancan', '~> 1.12.0'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'bootstrap-sass', '~> 3.3.5'
  s.add_dependency 'momentjs-rails', '>= 2.9.0'
  s.add_dependency 'bootstrap3-datetimepicker-rails', '~> 4.15.35'
  s.add_dependency 'sass-rails', '~> 5.0.3'
  s.add_dependency 'coffee-rails', '~> 4.1.0'
  s.add_dependency 'bcrypt', '~> 3.1.10'
  s.add_dependency 'responders', '~> 2.0'
  s.add_dependency 'font-awesome-sass', '~> 4.3.2.1'
  s.add_dependency 'friendly_id', '~> 5.1.0'
  s.add_dependency 'babosa', '~> 1.0.2'
end
