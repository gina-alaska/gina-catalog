class CswImport < ActiveRecord::Base
  attr_accessible :title, :sync_frequency, :url, :metadata_field, :metadata_type
  
  belongs_to :setup
  has_many :catalogs
  has_many :activity_logs, as: :loggable
  
  METADATA_TYPES = [
    #['display text','type']
    ['FGDC', 'FGDC']
  ]
  
  def fgdc_import_url(record)
    record.links.select{|l| l.type == self.metadata_field }.first.try(:url)
  end
  
  def default_attributes
    {
      csw_import_id: self.id,
      owner_setup_id: self.setup_id,
      use_agreement_id: self.use_agreement_id,
      request_contact_info: self.request_contact_info,
      require_contact_info: self.require_contact_info
#      collections: self.collections
    }
  end
  
  def async_import(force = false)
    Resque.enqueue(CswImportWorker, self.id, force)
  end
  
end
