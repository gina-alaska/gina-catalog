class GeojsonLayer < MapLayer

  def supports?(projection)
    false
  end

  def layer_type
    'GeoJSON'
  end

  def leaflet_options
    opts = super()
    opts['geojson-options'] = 'custom-marker'
    opts['cluster'] = 'true'
    opts
  end
end
