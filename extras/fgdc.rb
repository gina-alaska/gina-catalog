class FGDC
  attr_reader :xml

  def initialize url
    puts "Fetching metadata"
    @xml = Nokogiri::HTML(open(url))
    puts "metadata fetched"
  end

  def title
    @xml.search('idinfo citation citeinfo title').children.to_s.strip
  end

  def abstract
    @xml.search('idinfo abstract').children.to_s
  end

  def keywords
    @xml.search('idinfo keywords').search('themekey','placekey').children.collect { |tag|
      tag.to_s.split(/\s*[;,:]\s*/)
    }.flatten.to_a.join(', ')
  end

  def start_date
    parse_date @xml.search('idinfo timeperd timeinfo rngdates begdate').children.to_s.strip
  end

  def end_date
    parse_date @xml.search('idinfo timeperd timeinfo rngdates enddate').children.to_s.strip, true
  end

  def parse_date(raw_date, end_of_year = false)
    return nil if ['', 'present', 'unknown'].include? raw_date.downcase

    begin
      date = DateTime.parse raw_date
    rescue
      date = DateTime.strptime(raw_date, "%Y")
      if end_of_year
        date = date.end_of_year
      else
        date = date.beginning_of_year
      end
    rescue
      nil
    end

    date
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

  def status
    case @xml.search('idinfo status progress').children.to_s.strip.chomp.downcase
    when 'complete'
      "Complete"
    when 'in work'
      "Ongoing"
    when 'ongoing'
      "Ongoing"
    else
      "Unknown"
    end
  end

  def onlinks
    @xml.search('idinfo onlink').children.collect(&:to_s)
  end

  def primary_contact
    contact(@xml.search('idinfo ptcontac cntinfo'))
  end

  def other_contacts
    @xml.search('cntinfo').collect { |xml_node|
      contact(xml_node)
    }.compact.uniq
  end

  def contact(xml_node)
    contact = nil

    unless xml_node.children.empty?
      name = xml_node.search('cntper').children.to_s
      return nil if name.nil? or name.blank?

      if name.split(",").count == 1 #No comma, assume First Last
        contact = {first_name: name.split.first, last_name: name.split.last}
      else #Comma in the name, assume Last, First
        split_name = Array.wrap(name.split(","))
        contact = {first_name: split_name.pop.lstrip, last_name: split_name.join(',') }
      end

      contact[:email] = xml_node.search('cntemail').children.to_s
      contact[:job_title] = xml_node.search('cntpos').children.to_s
      contact[:phone_numbers] = {
        work: xml_node.search('cntvoice').children.to_s
      }

    end

    contact
  end

  def primary_agency
    @xml.search('idinfo cntorgp cntorg').children.map do |child|
      child.to_s.strip
    end
  end

  def agencies
    @xml.search('cntorgp cntorg').children.map do |child|
      child.to_s.strip
    end
  end

  def funding_agency
  end

  private

end
