class DownloadUrl < ActiveRecord::Base
  belongs_to :catalog
  has_many :activity_logs, as: :loggable, order: "created_at DESC", extend: DownloadActivityExtension
  
  before_save :update_uuid
  
  validates_presence_of :url
  
  def to_param
    self.uuid
  end

  def update_uuid
    self.uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, self.url).to_s
  end
end
