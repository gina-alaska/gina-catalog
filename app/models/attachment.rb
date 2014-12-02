class Attachment < ActiveRecord::Base
  INTERACTIONS = [
    'Previewable',
    'Downloadable'
  ]

  dragonfly_accessor :file

  belongs_to :entry

  scope :downloadable, -> { where(interaction: "Downloadable") }
  scope :previewable, -> { where(interaction: "Previewable") }

  before_create :create_uuid

  validates :description, length: { maximum: 255 }

  def create_uuid
    self.uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, self.file_uid).to_s
  end

  def to_param
    self.uuid
  end

end
