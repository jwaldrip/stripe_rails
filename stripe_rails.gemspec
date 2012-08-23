$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "stripe_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "stripe_rails"
  s.version     = StripeRails::VERSION
  s.authors     = ["Jason Waldrip"]
  s.email       = ["jason@waldrip.net"]
  s.homepage    = "https://github.com/jwaldrip/stripe_rails"
  s.summary     = "Stripe Rails was built on top of the official stripe gem for easier integration into a rails project."
  s.description = "Stripe Rails was built on top of the official stripe gem to bring ease of use of stripe in your models. The gem also uses your applications cache to store objects locally so that you dont have to continuously hit Stripes API, it wont have to reach the stripe API on every page load. Lastly, this gem has built in responses for stripe webhooks/callbacks."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.textile"]

  s.add_dependency "rails"
  s.add_dependency "jquery-rails"
  s.add_dependency "stripe"

  s.add_development_dependency "rspec-rails"

end
