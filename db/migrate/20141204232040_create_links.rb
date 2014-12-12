class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :category
      t.string :display_text
      t.string :url
      t.integer :entry_id
      t.boolean :valid_link, default: true
      t.date :last_checked_at

      t.timestamps
    end
  end
end
