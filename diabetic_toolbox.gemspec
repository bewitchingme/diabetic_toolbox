$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "diabetic_toolbox/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "diabetic_toolbox"
  s.version     = DiabeticToolbox::VERSION
  s.authors     = ["bewitchingme"]
  s.email       = ["rpc@bewitching.me"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of DiabeticToolbox."
  s.description = "TODO: Description of DiabeticToolbox."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.3"

  s.add_development_dependency "pg"
end
