class Invitation < ActiveRecord::Base
  belongs_to :portal
  belongs_to :permission

  accepts_nested_attributes_for :permission

  validates :name, presence: true
  validates :email, presence: true
  validates :uuid, presence: true

  before_validation :create_uuid

  def create_uuid
    return unless uuid.nil?
    return if email.nil?

    self.uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, email).to_s
  end

  def to_param
    uuid
  end
end
