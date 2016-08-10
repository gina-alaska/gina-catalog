class Bound < ActiveRecord::Base
  # module Factories
  #   GEO = RGeo::Geographic.simple_mercator_factory
  #   PROJECTED = GEO.projection_factory
  # end

  # set_rgeo_factory_for_column(:geom, Factories::PROJECTED)

  belongs_to :boundable, polymorphic: true

  def from_geojson(data)
    geojson = RGeo::GeoJSON.decode(data, json_parser: :json)

    if geojson.count > 1
      bbox = bbox_for_multiple_features(geojson)
    else
      bbox = bbox_for_single_feature(geojson.first)
    end

    self.geom = bbox
    self
  end

  def srs_database
    @srs_database ||= RGeo::CoordSys::SRSDatabase::ActiveRecordTable.new
  end

  def factory
    @factory ||= RGeo::Geos.factory(srs_database: srs_database, srid: 4326)
  end

  # def bbox
  #   @bbox ||= RGeo::Cartesian::BoundingBox.new(factory)
  # end

  def bbox_for_single_feature(feature)
    # bbox = RGeo::Cartesian::BoundingBox.new(factory)
    # bbox.add(feature.geometry)
    # bbox
    RGeo::Feature.cast(feature.geometry, factory: factory, :project => true)
  end

  def bbox_for_multiple_features(features)
    bbox = RGeo::Cartesian::BoundingBox.new(factory)
    features.each { |feature| bbox.add(feature.geometry) }

    bbox.to_geometry
  end

  def centroid
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
