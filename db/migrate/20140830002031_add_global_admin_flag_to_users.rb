class AddGlobalAdminFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :global_admin, :boolean
  end
end