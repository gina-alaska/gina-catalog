class FixGeoKeywordGeomType < ActiveRecord::Migration
  def up
    change_column :geokeywords, :geom, :geometry, :srid => 4326
    add_column :geokeywords, :llgeom, :geometry, :srid => 4326
    Geokeyword.update_all('llgeom = geom')
    remove_column :geokeywords, :geom
    add_column :geokeywords, :geom, :geometry, :srid => 4326
    Geokeyword.update_all('geom = llgeom')
    # remove_column :geokeywords, :llgeom   
  end

  def down
    remove_column :geokeywords, :llgeom
    # change_column :geokeywords, :geom, :point, :srid => 4326
  end
end
