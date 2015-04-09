class CreateArchiveItems < ActiveRecord::Migration
  def change
    create_table :archive_items do |t|
      t.text :message
      t.integer :archived_id
      t.string :archived_type
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
