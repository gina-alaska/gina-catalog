class PageImage < ActiveRecord::Base
  attr_accessible :image_id, :page_id
  
  belongs_to :page
  belongs_to :image
end
