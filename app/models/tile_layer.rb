class TileLayer < MapLayer
  validates :projections, presence: true
  
  def supports?(projection)
    self.projection == projection ? true : false
  end

  def supports_layers?
    false
  end
  
  def to_s
    "TILE :: #{super}"
  end
end