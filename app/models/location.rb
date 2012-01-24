class Location < ActiveRecord::Base
  acts_as_geom :geom => :geometry

  belongs_to :asset, :polymorphic => true

  def geom_coords
    geom.try(:text_representation)
  end

  def geom_type
    geom.try(:text_geometry_type)
  end

  def wkt
    geom.try(:as_wkt)
  end

  def wkt=(text)
    self.geom = Geometry.from_ewkt(text) unless text.empty? or text.nil?
    self.geom.srid = 4326
  end

  def self.intersects(geom)
    where("ST_Intersects(geom, GeomFromEWKT(?))", geom.as_hex_ewkb)
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
      :wkt => self.geom.try(:as_wkt)
    }
  end

  def center
    self.geom.envelope.center unless self.geom.nil?
  end
  
end
