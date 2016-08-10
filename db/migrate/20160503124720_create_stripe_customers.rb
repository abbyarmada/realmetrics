class CreateStripeCustomers < ActiveRecord::Migration
  def change
    create_table :stripe_customers do |t|
      t.references :organization, index: true, foreign_key: true

      t.string :guid
      t.string :provider

      t.string :email
      t.integer :account_balance
      t.datetime :created_at
      t.string :currency
      t.boolean :delinquent
    end

    add_index :stripe_customers, [:organization_id, :guid, :provider], unique: true, name: 'idx_uk_stripe_customers'
  end
end
