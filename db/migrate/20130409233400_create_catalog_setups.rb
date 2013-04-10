class CreateCatalogSetups < ActiveRecord::Migration
  def change
    add_column :catalogs_setups, :id, :primary_key
  end
end
