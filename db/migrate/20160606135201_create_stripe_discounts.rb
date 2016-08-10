class CreateStripeDiscounts < ActiveRecord::Migration
  def change
    create_table :stripe_discounts do |t|
      t.references :organization, index: true, foreign_key: true

      t.string :provider

      t.string :coupon_guid
      t.string :customer_guid
      t.string :subscription_guid

      t.datetime :started_at
      t.datetime :ended_at
    end

    add_index :stripe_discounts, [:organization_id, :provider, :coupon_guid, :customer_guid, :subscription_guid], unique: true, name: 'idx_uk_stripe_discounts'
  end
end
