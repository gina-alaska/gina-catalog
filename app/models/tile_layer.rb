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
end