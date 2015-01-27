class Bound < ActiveRecord::Base
  module Factories
    GEO = RGeo::Geographic.simple_mercator_factory
    PROJECTED = GEO.projection_factory
  end

  set_rgeo_factory_for_column(:geom, Factories::PROJECTED)

  belongs_to :boundable, polymorphic: true

  def from_geojson(data)
    srs_database = RGeo::CoordSys::SRSDatabase::ActiveRecordTable.new
    factory = RGeo::Geos.factory(:srs_database => srs_database, :srid => 4326)
    cartesian_preferred_factory = Bound.rgeo_factory_for_column(:geom)

    geojson = RGeo::GeoJSON.decode(data, :json_parser => :json)

    bbox = RGeo::Cartesian::BoundingBox.new(factory)
    geojson.each { |feature| bbox.add(feature.geometry) }

    self.geom = bbox.to_geometry
    self
  end

  def centroid
    self.geom.envelope.point_on_surface
  end

  def as_geojson
    RGeo::GeoJSON.encode(geom)
  end
end
