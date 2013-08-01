class CswImportWorker 
  include Sidekiq::Worker

  def perform(csw_id)
    @csw_import = CswImport.where(id: csw_id).first
    
    client = RCSW::Client::Base.new(@csw_import.url)
    
    records = client.record(client.records.collect(&:identifier)).all
    
    records.each do |record|
      uuid = record.identifier.gsub(/({|})/,"")
      
      catalog = Catalog.where(uuid: uuid, csw_import_id: @csw_import.id).first_or_initialize

      #Todo:  If the tags/locations change, do the old ones get deleted?
      catalog.update_attributes({
        title: record.title,
        tags: record.subject,
        description: record.abstract,
        type: csw_type_to_catalog_type(record.type),
        locations: csw_bounds_to_location(record.wgs84_bounds)
      })
    end
    
    @csw_import.touch
  end
  
  def self.queue_imports
    @csw_imports = CswImport.all
  
    @csw_imports.each do |csw| 
      if csw.updated_at > Time.now - csw.sync_interval.hours
        CswImportWorker.perform_async(csw.id)
      end
    end
  end
  
  private
  #TODO: Is wgs84_bounds always a single bounding box?
  # Multiple bounding boxes needs to be handled if not. 
  def csw_bounds_to_location(bounds)
    unless bounds.nil?
      factory = RGeo::Geographic.simple_mercator_factory(srid: 4326)
    
      lower_corner = bounds.lower_corner.split
      upper_corner = bounds.upper_corner.split
    
      lower_point = factory.point(lower_corner.first, lower_corner.last)
      upper_point = factory.point(upper_corner.first, upper_corner.last)

      geom = RGeo::Cartesian::BoundingBox.create_from_points(lower_point, upper_point).to_geometry
    
      Location.where(geom: geom).first_or_initialize
    else 
      nil
    end
  end
  
  def csw_type_to_catalog_type(type)
    case type
    when 'placeholder','somethingelse'
    else
      'Asset'
    end
  end
end
