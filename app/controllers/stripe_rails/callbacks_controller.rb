require_dependency "stripe_rails/application_controller"

module StripeRails
  class CallbacksController < ApplicationController
    def post
      render text: 'callback request here!'
    end
  end
end
