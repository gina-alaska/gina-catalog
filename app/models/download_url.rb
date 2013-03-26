class DownloadUrl < ActiveRecord::Base
  belongs_to :catalog
  
  before_save :update_uuid
  
  validates_presence_of :url

  def update_uuid
    self.uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, self.url).to_s
  end
end
