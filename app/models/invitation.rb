class Invitation < ActiveRecord::Base
  belongs_to :portal
  belongs_to :permission

  accepts_nested_attributes_for :permission

  validates :name, presence: true
  validates :email, presence: true
  validates :uuid, presence: true

  before_create :create_uuid

  def create_uuid
    self.uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, self.email).to_s
  end

  def to_param
    self.uuid
  end
end
