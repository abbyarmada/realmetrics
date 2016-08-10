class CreateStripeSubscriptions < ActiveRecord::Migration
  def change
    create_table :stripe_subscriptions do |t|
      t.references :organization, index: true, foreign_key: true

      t.string :guid
      t.string :provider

      t.string :customer_guid
      t.string :plan_guid

      t.datetime :created_at

      t.datetime :started_at
      t.datetime :ended_at

      t.datetime :trial_started_at
      t.datetime :trial_ended_at

      t.string :status
      t.integer :quantity
      t.decimal :tax_percent

      t.boolean :cancel_at_period_end
      t.datetime :canceled_at

      t.datetime :current_period_end_at
      t.datetime :current_period_started_at
    end

    add_index :stripe_subscriptions, [:organization_id, :guid, :provider], unique: true, name: 'idx_uk_stripe_subscriptions'
  end
end
