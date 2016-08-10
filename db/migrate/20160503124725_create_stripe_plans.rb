class CreateStripePlans < ActiveRecord::Migration
  def change
    create_table :stripe_plans do |t|
      t.references :organization, index: true, foreign_key: true

      t.string :guid
      t.string :provider

      t.string :name
      t.string :statement_descriptor
      t.integer :trial_period_days
      t.datetime :created_at
      t.integer :amount
      t.string :currency
      t.string :interval
      t.integer :interval_count
    end

    add_index :stripe_plans, [:organization_id, :guid, :provider], unique: true, name: 'idx_uk_stripe_plans'
  end
end
