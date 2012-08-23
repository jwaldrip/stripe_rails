class CreateStripeRailsCustomers < ActiveRecord::Migration
  def change
    create_table :stripe_rails_stripe_customers do |t|
      t.primary :stripe_customer_id
    end
  end
end