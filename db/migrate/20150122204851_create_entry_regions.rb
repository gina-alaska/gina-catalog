class CreateEntryRegions < ActiveRecord::Migration
  def change
    create_table :entry_regions do |t|
      t.integer :entry_id
      t.integer :region_id

      t.timestamps
    end
  end
end
