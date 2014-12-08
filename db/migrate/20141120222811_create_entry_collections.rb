class CreateEntryCollections < ActiveRecord::Migration
  def change
    create_table :entry_collections do |t|
      t.integer :collection_id
      t.integer :entry_id

      t.timestamps
    end
  end
end
