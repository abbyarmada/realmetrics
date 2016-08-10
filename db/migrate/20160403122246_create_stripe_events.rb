class CreateStripeEvents < ActiveRecord::Migration
  def change
    create_table :stripe_events do |t|
      t.references :organization, index: true, foreign_key: true

      t.string :guid
      t.string :provider

      t.datetime :created_at
      t.string :event_type
      t.text :event_data
    end

    add_index :stripe_events, [:organization_id, :guid, :provider], unique: true, name: 'idx_uk_stripe_events'
  end
end
