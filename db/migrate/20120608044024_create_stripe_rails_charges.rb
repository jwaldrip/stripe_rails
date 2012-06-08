class CreateStripeRailsCharges < ActiveRecord::Migration
  def change
    create_table :stripe_rails_charges do |t|

      t.timestamps
    end
  end
end
