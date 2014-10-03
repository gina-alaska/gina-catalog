class SiteUrl < ActiveRecord::Base
  attr_accessible :site_id, :url, :default
  
  belongs_to :setup

  def to_s
  	self.url
  end
end
