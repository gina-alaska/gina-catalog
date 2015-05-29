class TmsLayer < MapLayer
  def supports?(projection)
    projections.blank? ? true : !projections.match(projection).nil?
  end

  def layer_type
    'TMS'
  end
end
