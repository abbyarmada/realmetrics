class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :organization, index: true, foreign_key: true

      t.string :provider
      t.string :uid

      t.string :publishable_key
      t.string :token
      t.string :user_id

      t.timestamps null: false
    end

    add_index :identities, [:organization_id, :provider, :uid], unique: true, name: 'idx_uk_identities'
  end
end
