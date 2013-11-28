class AddAreaManagementToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :cms_enabled, :boolean, default: true
    add_column :setups, :catalog_enabled, :boolean, default: true
    add_column :setups, :settings_enabled, :boolean, default: true
    add_column :setups, :permissions_enabled, :boolean, default: true
  end
end
