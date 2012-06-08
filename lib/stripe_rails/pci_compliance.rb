module Stripe::PciCompliance
  ::Stripe::Token.send :define_singleton_method, :create do
    raise "Method disabled due to pci compliance!"
  end

  # Todo: Add errors when card is passed in options!
end