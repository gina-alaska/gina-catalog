class Geokeyword < ActiveRecord::Base
  has_and_belongs_to_many :catalogs
  
  set_rgeo_factory_for_column(:geom, RGeo::Geographic.simple_mercator_factory(:srid => 4326))

  def self.intersects(wkt, srid=4326)
    wkt = wkt.as_text if wkt.respond_to? :as_text
    where("ST_Intersects(geom, ?::geometry)", "SRID=#{srid};#{wkt}")
  end
end
