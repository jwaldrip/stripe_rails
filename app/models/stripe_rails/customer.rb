module StripeRails
  class Customer
    include Mongoid::Document
    include Mongoid::Timestamps::Updated

    attr_readonly :_id
    attr_accessible :data

    field :data, type: Hash, default: -> { Hash.new }
    field :_id, type: String

    def initialize(attributes={},options={})
      attributes = { data: attributes } if self.new_record?
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

    #private :attributes=, :update_attributes, :update_attributes!, :data

    def method_missing(meth, *args, &block)
      if data.has_key?(meth.to_s) && !meth =~ /=$/
        data[meth.to_s]
      elsif meth =~ /=$/ && %w(card= description= coupon= email=).include?(meth.to_s) && args.size == 1
        @customer.send meth, args.first
        self.data[meth.to_s.sub(/=$/,'').to_s] = args.first if %w(description= email=).include?(meth.to_s)
      elsif meth =~ /=$/ && !%w(card= description= coupon= email=).include?(meth.to_s)
        super
      elsif @customer.respond_to?(meth.to_sym)
        @customer.send meth, *args
      else
        super
      end
    end

    # Callbacks
    after_initialize   :stripe_read
    before_update      :stripe_update
    before_destroy     :stripe_destroy

    def delete(options={})
      customer = Stripe::Customer.construct_from(data)
      customer.delete
      super(options)
    end

    def refresh!
      @customer = Stripe::Customer.retrieve(id)
      self.update_attributes(data: @customer.to_hash)
      self
    end

    def status

    end

    def days_remaining_in_trial

    end

    def charge
      StripeRails::Charge.new(@customer)
    end

    private

    def refresh_from(stripe_object)
      raise "Is not a stripe customer!" unless stripe_object.kind_of? Stripe::StripeCustomer
      @customer = stripe_object
      self.attributes = { data: @customer.to_hash }
      self
    end

    # Using a callback so that we can call create and save on a new record
    def stripe_create
      self.data['description'] = _parent.stripe_description if _parent.respond_to? :stripe_description
      refresh_from Stripe::Customer.create(data)
      @customer.update_subscription(_parent.stripe_subscription) if _parent.respond_to? :stripe_subscription
      self._id = data[:id]
    end

    def stripe_read
      if !new_record? && updated_at && updated_at < 1.day.ago
        self.refresh!
      elsif new_record? and id
        @customer = Stripe::Customer.retrieve(id)
        self.attributes = { data: @customer.to_hash }
      else
        @customer = Stripe::Customer.construct_from(data)
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
