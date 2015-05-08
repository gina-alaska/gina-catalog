class GeojsonLayer < MapLayer

  def supports?(projection)
    false
  end

  def layer_type
    'GeoJSON'
  end
end
