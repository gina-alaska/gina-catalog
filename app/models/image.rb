class Image < ActiveRecord::Base
  attr_accessible :description, :file_uid, :link_to_url, :title, :file, :setups
  image_accessor :file
  
  has_and_belongs_to_many :setups
end
