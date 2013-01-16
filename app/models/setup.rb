class Setup < ActiveRecord::Base
  attr_accessible :logo_uid, :primary_color, :title, :by_line
  
  has_and_belongs_to_many :images
  has_and_belongs_to_many :carousel_images, class_name: 'Image', join_table: 'carousel_images_setups'
  has_and_belongs_to_many :pages
  has_and_belongs_to_many :page_layouts
  has_many :catalog_collections
  
  has_many :urls, class_name: 'SiteUrl', dependent: :destroy
  
  liquid_methods :title, :by_line, :carousel_images
end
