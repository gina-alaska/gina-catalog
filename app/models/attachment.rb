class Attachment < ActiveRecord::Base
  CATEGORIES = [
    'Primary Thumbnail',
    'Thumbnail',
    'Geojson',
    'Public Download',
    'Private Download',
    'Archive'
  ]

  dragonfly_accessor :file

  belongs_to :entry, touch: true
  has_one :bbox, class_name: 'Bound', as: :boundable, dependent: :destroy

  scope :primary_thumbnail, -> { where(category: 'Primary Thumbnail') }
  scope :thumbnail, -> { where(category: 'Thumbnail') }
  scope :geojson, -> { where(category: 'Geojson') }
  scope :private_download, -> { where(category: 'Private Download') }
  scope :public_download, -> { where(category: 'Public Download') }
  scope :archive, -> { where(category: 'Archive') }

  before_save :create_uuid
  after_save :create_bbox

  validates :category, inclusion: { in: Attachment::CATEGORIES }
  validates :description, length: { maximum: 255 }
  # validates :file_uid, presence: true
  # validates :uuid, presence: true

  include PublicActivity::Model

  tracked owner: proc {|controller, model| controller.send(:current_user)},
          entry_id: :entry_id,
          parameters: :activity_params

  def activity_params
    { attachment: :file_name  }
  end

  def create_uuid
    return unless uuid.nil?
    return if file_uid.nil?

    self.uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, file_uid).to_s
  end

  def to_param
    uuid
  end

  def create_bbox
    return unless category == 'Geojson'
    build_bbox.from_geojson(file.data).save
  end

  def name
    "Attachment-#{id}"
  end

  def global_id
    to_sgid(for: 'download')
  end
end
