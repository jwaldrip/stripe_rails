module StripeRails
  class Engine < Rails::Engine
    isolate_namespace StripeRails

    config.app_generators.stripe_callback :stripe_callback

    config.autoload_paths += Dir["#{config.root}/lib**/"]
    config.autoload_paths += Dir["#{config.root}/stripe_callbacks/**"]

  end
end
