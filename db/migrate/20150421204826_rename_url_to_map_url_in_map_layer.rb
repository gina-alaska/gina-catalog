class RenameUrlToMapUrlInMapLayer < ActiveRecord::Migration
  def change
    change_table :map_layers do |t|
      t.rename :url, :map_url
    end
  end
end
