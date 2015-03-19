$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dbhero/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dbhero"
  s.version     = Dbhero::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Dbhero."
  s.description = "TODO: Description of Dbhero."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.9"

  s.add_development_dependency "pg"
end
