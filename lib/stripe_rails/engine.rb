module StripeRails
  class Engine < Rails::Engine
    isolate_namespace StripeRails

    config.autoload_paths += Dir["#{config.root}/lib**/"]

    initializer "pci compliance" do
      ::Stripe::Token.send(:include, Stripe::PciCompliance) if Rails.application.config.respond_to?(:stripe_pci_compliance) && Rails.application.config.stripe_pci_compliance
    end

  end
end
