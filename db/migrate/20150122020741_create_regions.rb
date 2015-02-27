class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.geometry :geom, srid: 4326

      t.timestamps
    end
  end
end
