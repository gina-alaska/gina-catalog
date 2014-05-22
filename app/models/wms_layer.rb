class WmsLayer < MapLayer
  validates :layers, presence: true
  
  def supports?(projection)
    true
  end
  
  def type_name
    'WMS'
  end
end