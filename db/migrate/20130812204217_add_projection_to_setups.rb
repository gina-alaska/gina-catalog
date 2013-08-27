class AddProjectionToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :projection, :string
  end
end
