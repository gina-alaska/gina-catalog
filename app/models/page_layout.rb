class PageLayout < ActiveRecord::Base
  attr_accessible :content, :name, :default
  
  has_and_belongs_to_many :setups
end
