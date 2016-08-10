class CreateStripeCoupons < ActiveRecord::Migration
  def change
    create_table :stripe_coupons do |t|
      t.references :organization, index: true, foreign_key: true

      t.string :guid
      t.string :provider

      t.datetime :created_at
      t.integer :amount_off
      t.string :currency
      t.string :duration
      t.integer :duration_in_months
      t.integer :max_redemptions
      t.integer :percent_off
      t.integer :redeem_by
      t.integer :times_redeemed
      t.boolean :active
    end

    add_index :stripe_coupons, [:organization_id, :guid, :provider], unique: true, name: 'idx_uk_stripe_coupons'
  end
end
