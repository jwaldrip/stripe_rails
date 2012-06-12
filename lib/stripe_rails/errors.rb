module Stripe

  class PciComplianceError < StandardError
    def initialize(msg)
      super
    end
  end

  class InvalidObjectError < StandardError
    def initialize(msg)
      super
    end
  end

  class CollectionInvalidError < StandardError
    def initialize(msg)
      super
    end
  end

  class PriceInvalidError < StandardError
    def initialize(msg)
      super
    end
  end

  class ChargeAssociationError < StandardError
    def initialize(msg)
      super
    end
  end

  class InvalidEventError < StandardError
    def initialize(msg='Event is invalid!')
      super
    end
  end

  class InvalidCallbackResponseError < StandardError
    def initialize(msg='Response must be a hash!')
      super
    end
  end

end