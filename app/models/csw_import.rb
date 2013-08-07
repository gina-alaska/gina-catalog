class CswImport < ActiveRecord::Base
  attr_accessible :title, :sync_frequency, :url, :metadata_field, :metadata_type
  
  belongs_to :setup
  has_many :catalogs
   
  METADATA_TYPES = [
    #['display text','type']
    ['FGDC', 'FGDC']
  ]
  
  def fgdc_import_url(record)
    record.links.select{|l| l.type == self.metadata_field }.first.try(:url)
  end
  
  def default_attributes
    {
      owner_setup_id: self.setup_id
      #sds_use_agreements
    }
  end
  
end
