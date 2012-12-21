class Image < ActiveRecord::Base
  attr_accessible :description, :file_uid, :link_to_url, :title, :file, :setups
  image_accessor :file
  
  has_and_belongs_to_many :setups
  has_many :page_images
  has_many :pages, :through => :page_images
  
  liquid_methods :title, :description, :link_to_url, :image_url
  
  def image_url
    self.file.url
  end
  
  def to_liquid
    {
      'title' => self.title,
      'description' => self.description,
      'link_to_url' => self.link_to_url,
      'tag' => "<img src=\"#{self.file.thumb('640x480#').url}\" alt=\"#{self.title}\" />"
    }
  end
end
