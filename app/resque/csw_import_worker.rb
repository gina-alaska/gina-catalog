class CswImportWorker 
  @queue = :imports
 
  def self.perform(csw_id)
    @csw = CswImport.where(id: csw_id).first
    failed_imports = []
    import_errors = {}
    
    client = RCSW::Client::Base.new(@csw.url)
    records = client.record(client.records.collect(&:identifier)).all
    
    records.each do |record|
      uuid = record.identifier.gsub(/({|})/,"")
      
      catalog = Catalog.where(uuid: uuid, csw_import_id: @csw.id).first_or_initialize

      if catalog.new_record? or catalog.remote_updated_at != record.modified
        url = @csw.fgdc_import_url(record)
        
        default_attributes = { 
          remote_updated_at: record.modified, 
          source_url: url
        }.merge(@csw.default_attributes)
        
        catalog.assign_attributes(default_attributes)

        import_errors[url] = case @csw.metadata_type
        when "FGDC"
          catalog.import_from_fgcd(url)
        end

        unless catalog.save
          failed_imports << url
        end
      end
    end
    Sunspot.commit
    @csw.touch
  end
  
  
end
