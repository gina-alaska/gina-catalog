class MapLayer < ActiveRecord::Base
  module Factories
    GEO = RGeo::Geographic.simple_mercator_factory(srid: 4326)
    PROJECTED = GEO.projection_factory
  end

  set_rgeo_factory_for_column(:bounds, Factories::PROJECTED)

  scope :wms, -> { where(type: 'WmsLayer') }
  
  def supports?(projection)
    self.projections.include?(projection)
  end
  
  def to_s
    "#{self.name} (#{self.type})"
  end
  
  def as_json(opts)
    opts.merge!({
      :only => [:id, :type, :name, :url, :projections, :layers, :catalog_id, :bounds, :created_at, :updated_at]
    })
    super(opts)
  end
  
  def to_s
    self.name
  end
end
