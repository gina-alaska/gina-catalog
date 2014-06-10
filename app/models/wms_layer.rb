class WmsLayer < MapLayer
  validates :layers, presence: true
  
  def supports?(projection)
    true
  end
  
  def to_s
    "WMS :: #{super}"
  end
  
  def layers_help
    "This is required for WMS layers, for example: modis,global_mosaic"
  end

  def projection_placeholder
    "Leave blank to support all projections"
  end

  def layers_placeholder
    "Specify at least one layer"
  end

  def url_help
    ""
  end
end