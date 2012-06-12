module StripeRails
  class Customer

    # Support for mongoid
    include Mongoid::Document
    include Mongoid::Timestamps

    store_in collection: "stripe_customers"

    field :data, type: String, default: -> { nil }
    field :unit_price, type: Float
    field :_id, type: String, default: -> { nil }

    attr_readonly :_id

    def charges
      StripeRails::Charge.new(@customer)
    end

    ActionDispatch::Session::CookieStore

    def invoices
      StripeRails::Invoice.new(@customer)
    end

    def initialize(attributes={}, options={})
      attributes = { data: attributes.to_json.to_a.pack('m') } if self.new_record?
      super(attributes,options)
    end

    # All returns items from the stripe API
    def self.all(*args)
      return super(nil) if args.first && args.first[:local] == true
      Stripe::Customer.all(*args)
    end

    def self.find(id)
      customer = self.find_or_initialize_by(_id: id)
      customer.save if customer.new_record?
      customer
    end

    # Privatize methods that can potential break caching and updating
    class << self
      alias :retrieve :find
      private :find_by
    end

    private :attributes=, :update_attributes, :update_attributes!

    def method_missing(meth, *args, &block)
      if @customer.respond_to?(meth.to_sym)
        value = @customer.send meth, *args
        refresh_from @customer
        value
      elsif meth =~ /=$/ && %w(card= description= coupon= email=).include?(meth.to_s)
        value = @customer.send meth, *args
        refresh_from @customer
        value
      else
        super
      end
    end

    # Callbacks
    after_initialize   :stripe_read
    before_update      :stripe_update
    before_destroy     :stripe_destroy

    def delete(options={})
      @customer.delete
      super(options)
    end

    def refresh!
      @customer = Stripe::Customer.retrieve(id)
      send :data=, @customer.to_json.to_a.pack('m')
      save
      self
    end

    def days_remaining_in_trial
      if subscription && subscription.status == 'trialing'
        ((Time.at(subscription.trial_end) - Time.now) / 24 / 60 / 60).ceil
      elsif subscription
        0
      else
        nil
      end
    end

    # Using a callback so that we can call create and save on a new record
    def create_customer
      params = {}
      params['description'] = stripe_customer.stripe_description if stripe_customer.respond_to? :stripe_description
      refresh_from Stripe::Customer.create(params)

      if stripe_customer.respond_to? :stripe_subscription_plan
        @customer.update_subscription({ plan: stripe_customer.stripe_subscription_plan })
        refresh_from @customer
      end

      self._id = @customer.id
      self.unit_price = stripe_customer.stripe_unit_price

      save
    end

    private

    def refresh_from(stripe_object)
      raise Stripe::InvalidObjectError, "Is not a stripe customer!" unless stripe_object.kind_of? Stripe::Customer
      @customer = stripe_object
      send :data=, @customer.to_json.to_a.pack('m')
      self
    end

    def stripe_read
      if !new_record? && updated_at && updated_at < 1.day.ago
        self.refresh!
      else
        @customer = Stripe::Customer.construct_from(JSON.parse data.unpack('m').first ) if data && data.unpack('m').first.present?
      end
    end

    def stripe_update
      refresh_from @customer.save
    end

    def stripe_destroy
      @customer.delete
    end

  end
end
