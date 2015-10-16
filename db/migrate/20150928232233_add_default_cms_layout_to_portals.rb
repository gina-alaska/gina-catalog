class AddDefaultCmsLayoutToPortals < ActiveRecord::Migration
  def change
    add_column :portals, :default_cms_layout_id, :integer
  end
end
