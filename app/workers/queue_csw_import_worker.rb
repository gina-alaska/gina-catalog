class QueueCswImportWorker 
  include Sidekiq::Worker
  
  def perform
    @csws = CswImport.all
  
    @csws.each do |csw| 
      if csw.updated_at > Time.now - csw.sync_frequency.hours
        CswImportWorker.perform_async(csw.id)
      end
    end
  end
end