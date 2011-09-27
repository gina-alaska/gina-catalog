class Region
  attr_accessor :attributes

  def initialize(attrs)
    @attributes = attrs
  end

  def self.find_by_name(name)
    Region.new(:name => name)
  end

  def name
    read_attribute(:name)
  end

  def name=(value)
    write_attribute(name, value)
  end

  def read_attribute(name)
    @attributes[name.to_sym]
  end

  def write_attribute(name, value)
    @attributes[name.to_sym] = value
  end

  def geom
    if read_attribute(:geom).nil?
      json = read_region_file

      jsongeom = json['features'].first['geometry']
      type, coords = jsongeom['type'], jsongeom['coordinates']
      geomclass = type.constantize
      write_attribute(:geom, geomclass.from_coordinates(coords))
    end

    read_attribute(:geom)
  end

  def reload!
    @json = nil
    read_region_file

    self
  end

  def read_region_file
    return nil if read_attribute(:name).nil?

    @json ||= JSON.parse(File.read(File.join(Rails.root, 'public/regions', read_attribute(:name) + '.geojson')))

    @json
  end
end