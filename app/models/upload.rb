class Upload < ActiveRecord::Base
  attr_accessible :catalog_id, :downloadable, :preview, :file, :catalog, :description
  
  dragonfly_accessor :file
  
  belongs_to :catalog
  has_many :logs, as: :loggable, class_name: 'ActivityLog', order: "created_at DESC", dependent: :destroy, extend: DownloadActivityExtension
  
  scope :downloadable, -> { where(downloadable: true) }
  scope :previews, -> { where(preview: true) }
  
  before_create :create_uuid
  
  def create_uuid
    self.uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, self.file_uid).to_s
  end
  
  def to_param
    self.uuid
  end
  
  # used to make work similar to the DownloadUrl model which has a url method
  def url
    self.file.try(:remote_url)
  end
end
