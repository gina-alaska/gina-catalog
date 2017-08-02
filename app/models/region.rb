class Region < ActiveRecord::Base
  include EntryDependentConcerns

  # module Factories
  #   GEO = RGeo::Geographic.simple_mercator_factory(srid: 4326)
  #   PROJECTED = GEO.projection_factory
  # end

  validates :name, length: { maximum: 255 }
  validates :name, uniqueness: true

  has_many :entry_regions
  has_many :entries, through: :entry_regions

  # set_rgeo_factory_for_column(:geom, Factories::PROJECTED)

  def self.intersects(wkt, srid = 4326)
    wkt = wkt.as_text if wkt.respond_to? :as_text
    where('ST_Intersects(geom, ?::geometry)', "SRID=#{srid};#{wkt}")
  end

  def geojson=(file)
    from_geojson(file.read)
  end

  def from_geojson(data)
    geojson_data = RGeo::GeoJSON.decode(data, json_parser: :json, geo_factory: Factories::GEO)
    logger.info(geojson_data.first.geometry.srid.to_s)
    self.geom = geojson_data.first.geometry
  end
end
