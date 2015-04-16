class MapLayer < ActiveRecord::Base
  module Factories
    GEO = RGeo::Geographic.simple_mercator_factory(srid: 4326)
    PROJECTED = GEO.projection_factory
  end

  searchkick word_start: [:name, :url, :type]

  validates :name, length: { maximum: 255 }, presence: true
  validates :url, length: { maximum: 255 }, presence: true
  validates :type, length: { maximum: 255 }
  validates :layers, length: { maximum: 255 }
  validates :projections, length: { maximum: 255 }

  belongs_to :entry

  set_rgeo_factory_for_column(:bounds, Factories::PROJECTED)

  scope :wms, -> { where(type: 'WmsLayer') }

  def supports?(projection)
    self.projections.include?(projection)
  end
  
  def as_json(opts)
    opts.merge!({
      :only => [:id, :type, :name, :url, :projections, :layers, :catalog_id, :bounds, :created_at, :updated_at]
    })
    super(opts)
  end
end
