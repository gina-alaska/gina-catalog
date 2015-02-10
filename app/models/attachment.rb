class Attachment < ActiveRecord::Base
  CATEGORIES = [
    'Thumbnail',
    'Geojson',
    'Public Download',
    'Private Download'
  ]

  dragonfly_accessor :file

  belongs_to :entry, touch: true
  has_one :bbox, class_name: 'Bound', as: :boundable

  scope :thumbnail, -> { where(category: 'Thumbnail') }
  scope :geojson, -> { where(category: 'Geojson') }
  scope :private_download, -> { where(category: 'Private Download') }
  scope :public_download, -> { where(category: 'Public Download') }

  before_validation :create_uuid
  after_save :create_bbox

  validates :description, length: { maximum: 255 }
  # validates :file_uid, presence: true
  # validates :uuid, presence: true

  def create_uuid
    return unless uuid.nil?
    return if file_uid.nil?

    self.uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, file_uid).to_s
  end

  def to_param
    uuid
  end

  def create_bbox
    build_bbox.from_geojson(file.data).save
  end
end
