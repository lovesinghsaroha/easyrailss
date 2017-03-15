$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "esrapr1/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "esrapr1"
  s.version     = Esrapr1::VERSION
  s.authors     = ["lovesinghsaroha"]
  s.email       = ["lovesinghsaroha@gmail.com"]
  #s.homepage    = "TODO"
  s.summary     = "Summary of Esrapr1."
  #s.description = "TODO: Description of Esrapr1."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.1"

  s.add_development_dependency "sqlite3"
end
