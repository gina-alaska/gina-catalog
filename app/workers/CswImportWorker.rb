class CswImportWorker 
  include Sidekiq::Worker

  def perform(csw_id)
    @csw_import = CswImport.where(id: csw_id).first
    
    #Do the work here
    
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
end
