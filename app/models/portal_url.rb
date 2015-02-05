class PortalUrl < ActiveRecord::Base
  belongs_to :portal

  validates :url, presence: true

  scope :default_url, -> { where(default: true) }
end
