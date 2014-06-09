class TileLayer < MapLayer
  validates :projections, presence: true
  
  def supports?(projection)
    self.projection == projection ? true : false
  end

  def supports_layers?
    false
  end
end