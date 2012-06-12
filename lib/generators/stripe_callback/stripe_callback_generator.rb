class StripeCallbackGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def initialize(args, *options) #:nodoc:
    args[0] = args[0].gsub(/\./,'_')
    super
  end

  def create_callback_file
    create_file "app/stripe_callbacks/#{file_name}_callback.rb", <<-FILE
class #{class_name}Callback < StripeRails::Callback

  # Some logic to process during the callback
  def actions

    # The response hash
    @response = {success: true}

  end

end
    FILE
  end
end
