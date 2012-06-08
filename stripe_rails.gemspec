$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "stripe_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "stripe_rails"
  s.version     = StripeRails::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of StripeRails."
  s.description = "TODO: Description of StripeRails."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.5"
  s.add_dependency "jquery-rails"
  s.add_dependency "stripe"
  s.add_dependency "mongoid", "~> 3.0.0.rc"

  s.add_development_dependency "rspec-rails"

end
