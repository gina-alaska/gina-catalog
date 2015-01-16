class RemoveObsoleteColumnsFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :portal_id, :integer
    remove_column :entries, :owner_portal_id, :integer
  end
end
