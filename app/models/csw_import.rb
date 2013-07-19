class CswImport < ActiveRecord::Base
  attr_accessible :title, :sync_frequency, :url
  
  belongs_to :setup
  has_many :catalogs
end
