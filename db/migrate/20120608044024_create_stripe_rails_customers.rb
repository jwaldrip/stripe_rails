class CreateStripeRailsCharges < ActiveRecord::Migration
  def change
    create_table :stripe_rails_charges do |t|
      t.text :data
      t.float :unit_price
      t.string :_id
      t.timestamps
    end
  end
end
