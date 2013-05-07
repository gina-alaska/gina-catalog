class SiteUrl < ActiveRecord::Base
  attr_accessible :site_id, :url, :hidden
  
  belongs_to :setup
end
