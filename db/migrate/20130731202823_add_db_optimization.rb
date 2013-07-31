class AddDbOptimization < ActiveRecord::Migration
  def up
    add_index :catalogs_setups, :catalog_id
    add_index :download_urls, :catalog_id
    add_index :repos, :catalog_id
    add_index :locations, :asset_id
  end

  def down
    remove_index :catalogs_setups, :catalog_id
    remove_index :download_urls, :catalog_id
    remove_index :repos, :catalog_id
    remove_index :locations, :asset_id
  end
end
