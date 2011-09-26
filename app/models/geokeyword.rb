class Geokeyword < ActiveRecord::Base
  has_and_belongs_to_many :catalogs

  def self.intersects(geom)
    where("ST_Intersects(geom, GeomFromEWKT(?))", geom.as_hex_ewkb)
  end
end
