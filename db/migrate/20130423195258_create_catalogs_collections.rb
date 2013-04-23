class CreateCatalogsCollections < ActiveRecord::Migration
  def change
    create_table :catalogs_collections do |t|
      t.integer :catalog_id
      t.integer :collection_id

      t.timestamps
    end
  end
end
