class SiteUrl < ActiveRecord::Base
  attr_accessible :site_id, :url, :default
  
  belongs_to :setup
end
