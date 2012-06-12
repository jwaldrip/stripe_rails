module StripeRails
  class Engine < Rails::Engine
    isolate_namespace StripeRails

    config.app_generators.stripe_callback :stripe_callback

    config.autoload_paths += Dir["#{config.root}/lib**/"]
    config.autoload_paths += Dir["#{config.root}/stripe_callbacks/**"]

    initializer "Pci Compliance" do
      ::Stripe::Token.send(:include, Stripe::PciCompliance) if Rails.application.config.respond_to?(:stripe_pci_compliance) && Rails.application.config.stripe_pci_compliance
      Rails.application.config.autoload_paths += Dir["#{Rails.root.to_s}/app/stripe_callbacks/**"]
    end

  end
end
