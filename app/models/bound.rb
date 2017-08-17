class Bound < ActiveRecord::Base
  # module Factories
  #   GEO = RGeo::Geographic.simple_mercator_factory
  #   PROJECTED = GEO.projection_factory
  # end

  # set_rgeo_factory_for_column(:geom, Factories::PROJECTED)

  belongs_to :boundable, polymorphic: true

  def from_geojson(data)
    geojson = RGeo::GeoJSON.decode(data, json_parser: :json)
    bbox = RGeo::Cartesian::BoundingBox.new(factory)
    geojson.each { |feature| bbox.add(feature.geometry) }
    self.geom = bbox.to_geometry
    self
  end

  def factory
    @factory ||= ::RGeo::Cartesian.preferred_factory(srid: 4326)
  end

  def centroid
    return if geom.nil?

    case geom.geometry_type
    when RGeo::Feature::Point
      geom
    when RGeo::Feature::Polygon
      geom.point_on_surface
    else
      logger.info geom.geometry_type
      nil
    end
  end

  def as_geojson
    RGeo::GeoJSON.encode(geom)
  end
end
