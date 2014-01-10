class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :message
      t.string :icon_name
      t.date :expire_date
      t.integer :setup_id

      t.timestamps
    end
  end
end
