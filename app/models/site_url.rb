class SiteUrl < ActiveRecord::Base
  belongs_to :site
  
  validates :url, presence: true
  
  scope :default_url, -> { where(default: true) }
end
