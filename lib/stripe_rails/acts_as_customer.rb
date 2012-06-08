module StripeRails::ActsAsCustomer
  extend ActiveSupport::Concern

  included do
    embeds_one :stripe, class_name: 'StripeRails::Customer', cascade_callbacks: true, autobuild: true
    before_create :create_stripe_customer

    StripeRails::Customer.send :embedded_in, self.to_s.downcase.to_sym, class_name: self.to_s

    def self.stripe_description(method)
      send :define_method, :stripe_description do
        send(method)
      end
    end

    def self.stripe_subscription_plan(plan)
      send :define_method, :stripe_subscription_plan do
        plan.to_s
      end
      send :private, :stripe_subscription_plan
    end

    def self.stripe_unit_price(price)
      send :define_method, :stripe_unit_price do
        raise 'Price is not a number!' unless price.kind_of?(Integer) || price.kind_of?(Float)
        price * 100
      end
      send :private, :stripe_unit_price
    end

    def self.stripe_units(collection)
      send :define_method, :stripe_units do
        raise 'Must be a collection!' unless send(collection.to_sym).respond_to?(:count)
        send(collection.to_sym).count
        send :private, :stripe_units
      end
    end

  end

  def create_stripe_customer
    self.stripe.send(:stripe_create)
  end

end