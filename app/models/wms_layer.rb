class WmsLayer < MapLayer
  validates :layers, presence: true
  
  def supports?(projection)
    self.projections.blank? ? true : !self.projections.match(projection).nil?
  end
  
  def to_s
    "WMS :: #{super}"
  end
end