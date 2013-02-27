class Page::Image < ActiveRecord::Base
  attr_accessible :image_id, :page_content_id
  
  belongs_to :page_content, class_name: 'Page::Content'
  belongs_to :image, class_name: '::Image'
end
