class CreateGeokeywords < ActiveRecord::Migration
  def self.up
    create_table :geokeywords do |t|
      t.string      :name
      t.point       :geom, :srid => 4326
      t.timestamps
    end
    create_table :catalogs_geokeywords, :id => false do |t|
      t.integer     :catalog_id
      t.integer     :geokeyword_id
    end
  end

  def self.down
    drop_table :catalogs_geokeywords
    drop_table :geokeywords
  end
end
