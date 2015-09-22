class AddParentIdToCmsPages < ActiveRecord::Migration
  def change
    add_column :cms_pages, :parent_id, :integer
    add_column :cms_pages, :sort_order, :integer
  end
end
