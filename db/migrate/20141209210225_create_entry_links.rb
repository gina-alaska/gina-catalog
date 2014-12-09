class CreateEntryLinks < ActiveRecord::Migration
  def change
    create_table :entry_links do |t|
      t.integer :entry_id
      t.integer :links_id

      t.timestamps
    end
  end
end
