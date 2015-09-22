class AddActiveThemeIdToPortal < ActiveRecord::Migration
  def change
    add_column :portals, :active_cms_theme_id, :integer
  end
end
