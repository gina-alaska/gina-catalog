class AddNestedSetFieldsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :parent_id, :integer
    add_column :sites, :lft, :integer
    add_column :sites, :rgt, :integer
    add_column :sites, :depth, :integer
  end
end
