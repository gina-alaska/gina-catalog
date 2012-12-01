class Setup < ActiveRecord::Base
  attr_accessible :logo_uid, :primary_color, :title, :by_line, :url
  
  has_and_belongs_to_many :images
  has_and_belongs_to_many :carousel_images, class_name: 'Image', join_table: 'carousel_images_setups'
end
