module Stripe
  class Customer < APIResource

    def refresh

      key = Digest::MD5.hexdigest "#{url}_#{@api_key}_stripe"

      value = Rails.cache.fetch key, expires_in: 1.hour, force: @force, compress: true do
        @force = false
        super.to_json
      end

      response = Util.symbolize_names Stripe::JSON.load value

      refresh_from(response, @api_key)

    end

    def refresh!
      @force = true
      refresh
    end

  end
end
