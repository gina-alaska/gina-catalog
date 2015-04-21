class WmsLayer < MapLayer
  validates :layers, presence: true

  def supports?(_projection)
    true
  end

  def to_s
    "WMS :: #{super}"
  end
end
