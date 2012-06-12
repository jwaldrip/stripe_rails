class PingCallback < StripeRails::Callback

  def actions
    @response = {success: 'true'}
  end

end
