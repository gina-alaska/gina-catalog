class AddAreaManagementToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :cms, :boolean, default: true
    add_column :setups, :data, :boolean, default: true
  end
end
