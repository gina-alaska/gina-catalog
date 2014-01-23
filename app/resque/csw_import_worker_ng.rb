class CswImportWorkerNg
  @queue = :imports_ng
 
  def self.perform(csw_id, force = false)
    csw = CswImport.where(id: csw_id).first
    csw.import!
  end
end