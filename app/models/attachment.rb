class Attachment < ActiveRecord::Base
  CATEGORIES = [
    'Thumbnail',
    'Geojson',
    'Public Download',
    'Private Download',
  ]

  dragonfly_accessor :file

  belongs_to :entry

  scope :thumbnail, -> { where(category: "Thumbnail") }
  scope :geojson, -> { where(category: "Geojson") }
  scope :private_download, -> { where(category: "Private Download") }
  scope :public_download, -> { where(category: "Public Download") }


  before_create :create_uuid

  validates :description, length: { maximum: 255 }

  def create_uuid
    self.uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, self.file_uid).to_s
  end

  def to_param
    self.uuid
  end

end
