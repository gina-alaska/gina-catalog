class WmsLayer < MapLayer
  validates :layers, presence: true

  def supports?(projection)
    projections.blank? || projections.match?(projection)
  end

  def layer_type
    'WMS'
  end
end
