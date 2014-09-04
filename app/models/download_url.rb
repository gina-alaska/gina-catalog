class DownloadUrl < ActiveRecord::Base
  belongs_to :catalog
  has_many :logs, as: :loggable, class_name: 'ActivityLog', order: "created_at DESC", dependent: :destroy, extend: DownloadActivityExtension
  
  before_save :update_uuid
  
  validates_presence_of :url
  
  def to_param
    self.uuid
  end
  
  def update_uuid
    self.uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, self.url).to_s
  end
  
  def to_s
    self.url
  end
end
