class PortalUrl < ActiveRecord::Base
  belongs_to :portal

  validates :url, presence: true

  scope :active_url, -> { where(active: true) }

  def self.find_active_url(url)
    active_url.where(url: url).first
  end
end
