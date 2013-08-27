class AddGoogleLayersToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :google_layers, :boolean, default: true
  end
end
