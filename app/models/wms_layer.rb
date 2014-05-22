class WmsLayer < MapLayer
  validates :layers, presence: true
  
  def supports?(projection)
    true
  end
  
  def layers_help
    "This is required for WMS layers, for example: modis,global_mosaic"
  end
  
  def to_s
    "WMS :: #{super}"
  end
end