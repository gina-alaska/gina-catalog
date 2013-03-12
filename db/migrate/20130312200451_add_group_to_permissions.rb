class AddGroupToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :group, :string
  end
end
