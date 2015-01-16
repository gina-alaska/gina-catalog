class RemoveActiveFromAgencies < ActiveRecord::Migration
  def change
    remove_column :agencies, :active, :boolean
  end
end
