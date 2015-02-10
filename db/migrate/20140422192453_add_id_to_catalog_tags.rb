class AddIdToCatalogTags < ActiveRecord::Migration
  def change
    add_column :catalog_tags, :id, :primary_key
  end
end
