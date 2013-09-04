class CreateMapLayers < ActiveRecord::Migration
  def change
    create_table :map_layers do |t|
      t.string :name
      t.string :url
      t.string :type
      t.string :projections
      t.string :layers
      t.spatial :bounds, srid: 4326
      t.references :catalog

      t.timestamps
    end
    add_index :map_layers, :catalog_id
  end
end
