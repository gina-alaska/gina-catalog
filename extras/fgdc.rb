class FGDC 
  def initialize url
    @xml = Nokogiri::HTML(open(url))
  end
  
  def title
    @xml.search('idinfo title').children.to_s
  end
  
  def abstract
    @xml.search('idinfo abstract').children.to_s
  end
  
  def keywords 
    @xml.search('idinfo keywords theme themekey').children.collect(&:to_s)
  end
  
  def bounds
    bounds = @xml.search('idinfo spdom bounding')
    factory = RGeo::Geographic.simple_mercator_factory(srid: 4326)
    
    westbc = bounds.search('westbc').children.to_s.to_f
    eastbc = bounds.search('eastbc').children.to_s.to_f
    northbc = bounds.search('northbc').children.to_s.to_f
    southbc = bounds.search('southbc').children.to_s.to_f
    
    lower_corner = factory.point(westbc, southbc)
    upper_corner = factory.point(eastbc, northbc)

    RGeo::Cartesian::BoundingBox.create_from_points(lower_corner, upper_upper_corner).to_geometry
  end

  def onlinks
    @xml.search('idinfo onlink').children.collect(&:to_s)
  end
  
  def primary_contact
    person = @xml.search('idinfo cntperp cntper').children.to_s
    
    if person.empty?
      nil
    else
      {first_name: person.split.first, last_name: person.split.last}
    end
  end
  
  def source_agency
    agency = @xml.search('idinfo cntorgp cntorg').children.
  end
  
  def funding_agency
  end

  def agencies
  end

end