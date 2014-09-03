class SiteUrl < ActiveRecord::Base
  belongs_to :site
  
  validates :url, presence: true
end
