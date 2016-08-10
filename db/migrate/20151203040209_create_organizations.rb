class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.references :user, index: true, foreign_key: true

      t.boolean :initial_crawl_completed, default: false

      t.timestamps null: false
    end
  end
end
