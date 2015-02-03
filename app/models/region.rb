class Region < ActiveRecord::Base
  validates :name, length: { maximum: 255 }
  validates_uniqueness_of :name
  
  has_many :entry_regions
  has_many :entries, through: :entry_regions
  
  set_rgeo_factory_for_column(:geom, RGeo::Geographic.simple_mercator_factory(:srid => 4326))

  def self.intersects(wkt, srid=4326)
    wkt = wkt.as_text if wkt.respond_to? :as_text
    where("ST_Intersects(geom, ?::geometry)", "SRID=#{srid};#{wkt}")
  end

  def geojson=(file)
    from_geojson(file.read)
  end

  def from_geojson(data)
    self.geom = RGeo::GeoJSON.decode(data, json_parser: :json).first.geometry
  end
end
