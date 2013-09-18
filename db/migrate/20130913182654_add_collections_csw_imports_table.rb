class AddCollectionsCswImportsTable < ActiveRecord::Migration
  def change
    create_table :collections_csw_imports, id: false do |t|
      t.integer :collection_id
      t.integer :csw_import_id
    end    
  end
end
