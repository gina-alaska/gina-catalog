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
    @xml.search('idinfo keywords').search('themekey','placekey').children.collect(&:to_s)
  end
  
  def start_date
    @xml.search('idinfo timeperd timeinfo rngdates begdate').children.to_s
  end
  
  def end_date
    @xml.search('idinfo timeperd timeinfo rngdates enddate').children.to_s
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

    RGeo::Cartesian::BoundingBox.create_from_points(lower_corner, upper_corner).to_geometry
  end

  def onlinks
    @xml.search('idinfo onlink').children.collect(&:to_s)
  end
  
  def primary_contact
    person = @xml.search('idinfo cntperp cntper').children.to_s
    
    if person.empty?
      nil
    else
      if person.split(",").count == 1 #No comma, assume First Last
        {first_name: person.split.first, last_name: person.split.last}
      else #Comma in the name, assume Last, First
        {first_name: person.split(",").last.lstrip, last_name: person.split(",").first}
      end
    end
  end
  
  def source_agency
    agency = @xml.search('idinfo cntorgp cntorg').children.to_s
    
    if agency.empty?
      nil
    else
      agency
    end
  end
  
  def funding_agency
  end

  def agencies
  end

  private

end