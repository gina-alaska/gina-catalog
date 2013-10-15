class CswImportWorker 
  @queue = :imports
 
  def self.perform(csw_id, force = false)
    if force
      puts 'wahoo'
    end
      
    @csw = CswImport.where(id: csw_id).first
    @csw.update_attribute(:status, "Fetching records")
    
    @log = @csw.activity_logs.build
    @log.activity = "CSW Import"
    @log.log = {
      failed: [],
      errors: {},
      new_catalogs: []
    }
    
    puts "Fetching client records"
    client = RCSW::Client::Base.new(@csw.url)
    records = client.record(client.records.collect(&:identifier)).all
    puts "Done fetching records"
  
    @csw.update_attribute(:status, "Importing 0 of #{records.count}")

    records.each_with_index do |record, index|
      uuid = record.identifier.gsub(/({|})/,"")
      
      catalog = Catalog.where(uuid: uuid, csw_import_id: @csw.id).first_or_initialize

      if force or catalog.new_record? or catalog.remote_updated_at != record.modified
        url = @csw.fgdc_import_url(record)
        
        default_attributes = { 
          remote_updated_at: record.modified, 
          source_url: url
        }.merge(@csw.default_attributes)
        
        catalog.assign_attributes(default_attributes)

        begin        
          import_errors = case @csw.metadata_type
          when "FGDC"
            catalog.import_from_fgcd(url)
          end
        
          if catalog.save
            @log.log[:new_catalogs] << catalog.id
            #Only keep the errors on imported records
            @log.log[:errors][url] = import_errors if import_errors.any?
          else
            @log.log[:failed] << url
          end
        rescue Exception => e
          puts "While importing #{url}"
          puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
          @log.log[:failed] << url
        end
      end
      if(index % 10 == 0)
        @csw.update_attribute(:status, "Importing #{index} of #{records.count}")
      end
    end
    
    @log.save
    
    @csw.update_attribute(:status, "Finished")
    Sunspot.commit
  end
end
