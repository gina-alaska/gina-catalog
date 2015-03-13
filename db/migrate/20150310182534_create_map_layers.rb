class CreateMapLayers < ActiveRecord::Migration
  def change
    create_table :map_layers do |t|
      t.string :name
      t.string :url
      t.string :type
      t.string :layers
      t.string :projections
      t.integer :entry_id
      t.geometry :bounds, srid: 4326

      t.timestamps null: false
    end
  end
end
