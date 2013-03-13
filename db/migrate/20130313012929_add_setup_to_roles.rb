class AddSetupToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :setup_id, :integer
  end
end
