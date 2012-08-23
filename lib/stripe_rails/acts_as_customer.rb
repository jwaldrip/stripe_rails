module StripeRails::ActsAsCustomer
  extend ActiveSupport::Concern

  included do

    # Mongoid
    if self.respond_to?(:field)
      field :stripe_customer_id
    elsif self.kind_of(ActiveRecord::Base)
      StripeRails::StripeCustomer.send :belongs_to, :stripe_customerable, class_name: self.to_s, polymorphic: true, dependent: :destroy
      has_one :stripe_customer, class_name: 'StripeRails::StripeCustomer', as: :stripe_customerable
      delegate :stripe_customer_id, :stripe_customer
    else
      raise "ORM is not supported, use ActiveRecord or Mongoid"
    end

    def stripe
      Stripe::Customer.retrieve(stripe_customer_id) if stripe_customer_id
    end

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
    return false if stripe
    params = {}
    params['description'] = stripe_description if respond_to? :stripe_description
    self.stripe_customer_id = Stripe::Customer.create(params).id

    #stripe.update_subscription(plan: stripe_subscription_plan }) if respond_to? :stripe_subscription_plan

    save!
  end

end