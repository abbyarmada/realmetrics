class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :organization, index: true, foreign_key: true

      t.integer :year
      t.integer :month
      t.string :metric
      t.integer :value

      t.timestamps null: false
    end

    add_index :goals, [:organization_id, :year, :month, :metric], unique: true, name: 'idx_uk_goals'
  end
end
