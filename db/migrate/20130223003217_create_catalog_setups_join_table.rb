class CreateCatalogSetupsJoinTable < ActiveRecord::Migration
  def change
    create_table :catalogs_setups, id: false do |t|
      t.integer :catalog_id
      t.integer :setup_id
    end
    
    add_index :catalogs_setups, :setup_id
  end
end
