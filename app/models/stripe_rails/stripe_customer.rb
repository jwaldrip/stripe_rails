module StripeRails
  if Object.const_defined? 'ActiveRecord'
    class StripeCustomer < ActiveRecord::Base

    end
  end
end
