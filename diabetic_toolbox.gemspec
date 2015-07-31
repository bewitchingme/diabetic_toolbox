$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "diabetic_toolbox/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "diabetic-toolbox"
  s.version     = DiabeticToolbox::VERSION
  s.authors     = ["bewitchingme"]
  s.email       = ["rpc@bewitching.me"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of DiabeticToolbox."
  s.description = "TODO: Description of DiabeticToolbox."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_runtime_dependency "rails", "~> 4.2.3"

  s.add_development_dependency "pg"
  s.add_runtime_dependency "devise", "~> 3.5.1"
  s.add_runtime_dependency "prawn", "~> 1.2.0"
  s.add_runtime_dependency "prawn-table", "~> 0.2.1"
  s.add_runtime_dependency "kaminari", "~> 0.16.3"
  s.add_runtime_dependency "chartkick", "~> 1.3.2"
  s.add_runtime_dependency "paperclip", "~> 4.3.0"
  s.add_runtime_dependency "groupdate", "~> 2.4.0"
  s.add_runtime_dependency "cancancan", "~> 1.12.0"
  s.add_runtime_dependency "boostrap-sass", "~> 0.0.2"
  s.add_runtime_dependency "sass-rails", "~> 5.0.3"
  s.add_runtime_dependency "coffee-rails", "~> 4.1.0"
end
