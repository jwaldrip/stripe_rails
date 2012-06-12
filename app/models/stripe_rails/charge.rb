module StripeRails
  class Charge

    def initialize(customer)
      @customer = customer
      raise Stripe::InvalidObjectError, 'Object is not a stripe customer!' unless @customer.kind_of? Stripe::Customer
    end

    def all(options = {})
      Stripe::Charge.all(options.merge({ customer: @customer.id }))
    end

    def create(amount, options = {})
      Stripe::Charge.create(options.merge({ amount: amount, customer: @customer.id }))
    end

    def retrieve(id)
      charge = Stripe::Charge.retrieve(id)
      raise Stripe::ChargeAssociationError, 'The charge does not belong to this customer!' unless charge.customer == @customer.id
    end

    def refund(id)
      retrieve(id).refund
    end

  end
end
