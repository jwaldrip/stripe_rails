module Stripe::PciCompliance
  ::Stripe::Token.send :define_singleton_method, :create do
    raise Stripe::PciComplianceError, "Method disabled due to pci compliance!"
  end
end