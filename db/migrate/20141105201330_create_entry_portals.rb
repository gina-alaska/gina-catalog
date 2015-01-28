class CreateEntryPortals < ActiveRecord::Migration
  def change
    create_table :entry_portals do |t|
      t.integer :portal_id
      t.integer :entry_id

      t.timestamps
    end
  end
end
