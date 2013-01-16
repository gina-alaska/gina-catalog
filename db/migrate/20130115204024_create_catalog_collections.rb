class CreateCatalogCollections < ActiveRecord::Migration
  def change
    create_table :catalog_collections do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
