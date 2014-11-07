class AddOwnerToEntryPortals < ActiveRecord::Migration
  def change
    add_column :entry_portals, :owner, :boolean
  end
end
