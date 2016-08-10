class CreateStripeTransactions < ActiveRecord::Migration
  def change
    create_table :stripe_transactions do |t|
      t.references :organization, index: true, foreign_key: true

      t.string :guid
      t.string :provider

      t.datetime :created_at
      t.string :currency
      t.integer :gross_amount
      t.integer :fee_amount
      t.integer :net_amount

      t.string :transaction_type
    end

    add_index :stripe_transactions, [:organization_id, :guid, :provider], unique: true, name: 'idx_uk_stripe_transactions'
  end
end
