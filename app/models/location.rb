class Location < ActiveRecord::Base
  set_rgeo_factory_for_column(:geom, RGeo::Geographic.simple_mercator_factory(:srid => 4326))

  belongs_to :asset, :polymorphic => true

  # def geom_coords
  #   geom.try(:text_representation)
  # end
  # 
  # def geom_type
  #   geom.try(:text_geometry_type)
  # end

  def wkt
    geom.try(:as_text)
  end

  # def wkt=(text)
  #   self.geom = Geometry.from_ewkt(text) unless text.empty? or text.nil?
  #   self.geom.srid = 4326
  # end

  def self.intersects(wkt, srid=4326)
    wkt = wkt.as_text if wkt.respond_to? :as_text
    where("ST_Intersects(geom, ?::geometry)", "SRID=#{srid};#{wkt}")
  end

  def to_json(*args)
    super(:only => [:id, :name, :region, :subregion, :created_at, :updated_at], :methods => [:wkt])
  end

  def to_xml(*args)
    args[0][:only] = [:name, :region, :subregion, :created_at, :updated_at]
    args[0][:methods] = [:wkt]
    super(*args)
  end

  def as_json(opts = {})
    {
      :id => self.id,
      :name => self.name,
      :region => self.region,
      :subregion => self.subregion,
      :wkt => self.wkt
    }
  end

  def center
  #   self.geom.envelope.center unless self.geom.nil?
    if self.geom.is_a? RGeo::Feature::Point
      self.geom
    elsif self.geom.is_a? RGeo::Feature::Polygon
      self.geom.point_on_surface
    end
  end
end
