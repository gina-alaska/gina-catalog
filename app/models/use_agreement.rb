class UseAgreement < ActiveRecord::Base
  has_many :catalogs
  belongs_to :setup
  
  validates_presence_of :title
  validates_presence_of :content
end
