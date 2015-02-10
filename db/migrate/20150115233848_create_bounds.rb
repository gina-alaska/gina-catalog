class CreateBounds < ActiveRecord::Migration
  def change
    create_table :bounds do |t|
      t.integer :boundable_id
      t.string :boundable_type
      t.geometry :geom, srid: 4326

      t.timestamps
    end
  end
end
