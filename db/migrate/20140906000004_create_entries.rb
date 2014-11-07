class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :slug
      t.string :uuid
      t.integer :portal_id
      t.integer :licence_id
      t.datetime :archived_at
      t.integer :published_at
      t.date :start_date
      t.date :end_date
      t.integer :owner_portal_id

      t.timestamps
    end
  end
end
