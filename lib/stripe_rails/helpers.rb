module Stripe
  class Customer < APIResource

    def days_remaining_in_trial
      if subscription && subscription.status == 'trialing'
        ((Time.at(subscription.trial_end) - Time.now) / 24 / 60 / 60).ceil
      elsif subscription
        0
      else
        nil
      end
    end

  end
end
