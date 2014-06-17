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

  def display_map_size(size)
    case(size)
      when "normal"
        "Default"
      when "large"
        "Large"
      when "small"
        "Small"
      else 
        "Unknown map size #{size}"
    end
  end
end
