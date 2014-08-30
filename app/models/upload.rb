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

  def thumbnail(size = '640x480#')
  #   if self.file.try(:image?) and self.file_stored? and !%w{ pdf kmz kml }.include?(self.file.format)
  #     self.file.thumb(size).encode(:png)
  #   else
  #     Image.document_image
  #   end
  # rescue Dragonfly::Job::Fetch::NotFound
  #   Image.document_image    
  # end
  
    OpenStruct.new({ url: helpers.cms_media_path(self.file_uid, size: size) })
  end

  def helpers
    Rails.application.routes.url_helpers
  end
  
  def self.document_image
    OpenStruct.new(url: ActionController::Base.helpers.asset_path('document.png'))
  end

  def to_liquid
    {
      'title' => self.file_name,
      'link_to_url' => self.file.remote_url,
      'description' => self.description,
      'thumb' => ::ImageTagDrop.new(self),
      'grayscale' => ::ProcessImageTagDrop.new(self, :grayscale),
      'tag' => "<img src=\"#{self.thumbnail.try(:url)}\" alt=\"#{self.file_name}\" />"
    }
  end
end
