class MapLayer < ActiveRecord::Base
  belongs_to :catalog
  attr_accessible :bounds, :layers, :name, :projections, :type, :url, :catalog_id, :catalog
  
  set_rgeo_factory_for_column(:bounds, RGeo::Geographic.simple_mercator_factory(:srid => 4326))
  
  validates :name, presence: true
  validates :url, presence: true
  # validates :projections, presence: true
  
  serialize :projections
  
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
