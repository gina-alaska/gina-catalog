class WmsLayer < MapLayer
  validates :layers, presence: true

  def supports?(projection)
    projections.blank? ? true : !projections.match(projection).nil?
  end

  def to_s
    "WMS :: #{super}"
  end
end
