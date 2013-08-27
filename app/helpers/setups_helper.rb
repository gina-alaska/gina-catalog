module SetupsHelper
  def display_projection(projection)
    case(projection)
      when "EPSG:3338"
        "#{projection} (Alaskan Albers)"
      when "EPSG:3572"
        "#{projection} (Polar)"
      when "EPSG:3857"
        "#{projection} (Web Mercator)"
      else 
        "No Projection"
    end
  end
end
