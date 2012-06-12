module StripeRails
  class Callback

    def initialize(data_hash)
      data_hash = OpenStruct.new data_hash
      event = Stripe::Event.retrieve(data_hash.id)
      raise Stripe::InvalidEventError unless event
      @response = {}
      self.actions
    end

    def actions
    end

    def response
      @response
    end

  end
end