class TmsLayer < MapLayer
  def supports?(projection)
    projections.blank? || projections.match?(projection)
  end

  def layer_type
    'TMS'
  end
end
