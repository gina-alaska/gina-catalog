class AddCatalogCollectionToCatalog < ActiveRecord::Migration
  def change
    create_table :catalog_collections_catalogs, id: false do |t|
      t.integer :catalog_id
      t.integer :catalog_collection_id
    end
  end
end
