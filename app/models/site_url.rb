class SiteUrl < ActiveRecord::Base
  attr_accessible :site_id, :url
  
  belongs_to :setup
end
