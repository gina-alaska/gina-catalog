class AddPortalIdToMapLayer < ActiveRecord::Migration
  def change
    add_reference :map_layers, :portal, index: true
    add_foreign_key :map_layers, :portals
  end
end
