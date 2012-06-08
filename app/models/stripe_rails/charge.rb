module StripeRails
  class Charge

    def initialize(customer)
      raise "Not a stripe customer!" unless customer.kind_of?(Stripe::Customer)
      @customer = customer
    end

    def create(amount, options = {})
      Stripe::Charge.create(options.merge({ amount: amount, customer: @customer.id }))
    end

    def all(options = {} )
      Stripe::Charge.all(options.merge({ customer: @customer.id }))
    end

    def retrieve(id)
      charge = Stripe::Charge.retrieve(id)
      raise 'The charge does not belong to this customer!' unless charge.customer == @customer.id
    end

    def refund(id)
      retrieve(id).refund
    end

  end
end
