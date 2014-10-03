class TileLayer < MapLayer
  validates :projections, presence: true
  
  def supports?(proj)
    self.projections.split(',').include?(proj)
  end

  def supports_layers?
    false
  end
  
  def to_s
    "TILE :: #{super}"
  end

  def url_help
    "The URL must include placeholders {x},{y}, and {z} which corresponds to the column, row, and zoom values required to display a tile, for example: http://tiles.gina.alaska.edu/tilesrv/bdl/tile/{x}/{y}/{z}.png"
  end

  def projection_placeholder
    "Enter at least one projection"
  end
end