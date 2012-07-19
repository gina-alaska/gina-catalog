class UseAgreement < ActiveRecord::Base
  has_many :catalogs
  
  validates_presence_of :title
  validates_presence_of :content
end
