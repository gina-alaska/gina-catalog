class ArcLayer < MapLayer
  def supports?(projection)
    true
  end

  def layers_help
    "Arc Layers are usually numbers, for example: 0,1,2"
  end
  
  def to_s
    "ARC :: #{super}"
  end
end