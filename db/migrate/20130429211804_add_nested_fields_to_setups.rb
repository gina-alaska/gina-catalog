class AddNestedFieldsToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :parent_id, :integer
    add_column :setups, :lft, :integer
    add_column :setups, :rgt, :integer
    add_column :setups, :depth, :integer
  end
end
