class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.date :download_date
      t.text :user_agent
      t.integer :user_id
      t.integer :attachment_id

      t.timestamps null: false
    end
  end
end
