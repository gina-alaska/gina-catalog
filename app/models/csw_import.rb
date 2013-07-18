class CswImport < ActiveRecord::Base
  attr_accessible :sync_frequency, :url
  
  belongs_to :setup
  has_many :catalogs
end
