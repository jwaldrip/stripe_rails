module StripeRails::ActsAsCustomer
  extend ActiveSupport::Concern

  included do
    has_one :stripe, class_name: 'StripeRails::Customer', autobuild: true, dependent: :destroy, as: :stripe_customer
    before_create :create_stripe_customer

    StripeRails::Customer.send :belongs_to, :stripe_customer, class_name: self.to_s, polymorphic: true
    StripeRails::Customer.send :validates_presence_of, :stripe_customer_id

    def self.stripe_description(method)
      send :define_method, :stripe_description do
        send(method)
      end
    end

    def self.stripe_subscription_plan(plan)
      send :define_method, :stripe_subscription_plan do
        plan.to_s
      end
    end

    def self.stripe_unit_price(price)
      send :define_method, :stripe_unit_price do
        raise Stripe::PriceInvalidError, 'Price is not a number!' unless price.kind_of?(Integer) || price.kind_of?(Float)
        price
      end
    end

    def self.stripe_units(collection)
      send :define_method, :stripe_units do
        raise Stripe::CollectionInvalidError, 'Must be a collection!' unless send(collection.to_sym).respond_to?(:count)
        send(collection.to_sym).count
      end
    end

  end

  def create_stripe_customer
    self.stripe.create_customer
  end

end