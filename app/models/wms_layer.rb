class WmsLayer < MapLayer
  validates :layers, presence: true
  
  def supports?(projection)
    true
  end
end