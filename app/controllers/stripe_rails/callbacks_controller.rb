require_dependency "stripe_rails/application_controller"

module StripeRails
  class CallbacksController < ApplicationController
    def post
      data = JSON.parse(request.body.read)
      callback_class = (data['type'].gsub(/\./,'_') + '_callback').camelize

      # Render not implemented (501) if the callback does not exist.

      return head :not_implemented unless Object.autoload_const_defined?(callback_class) && callback_class.constantize.superclass == StripeRails::Callback

      callback = callback_class.constantize.new(data)

      callback.actions

      render json: callback.response

    end
  end
end
