class AddLocationProjectionToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :location_projection, :string
  end
end
