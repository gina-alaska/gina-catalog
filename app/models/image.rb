class Image < ActiveRecord::Base
  attr_accessible :description, :file_uid, :link_to_url, :title, :file, :setups
  image_accessor :file
  
  has_and_belongs_to_many :setups
  has_many :page_images, class_name: 'Page::Image'
  has_many :pages, :through => :page_images, class_name: 'Page::Content'
  
  validates_length_of :description, :maximum => 255
  
  liquid_methods :title, :description, :link_to_url, :image_url
  
  def image_url
    self.file.url
  end
  
  def url
    url = self.link_to_url
    if url.nil? or url.empty?
      "#{self.file.url}"
    else
      url
    end
  end
  
  def to_liquid
    {
      'title' => self.title,
      'description' => self.description,
      'link_to_url' => self.url,
      'thumb' => ::ImageTagDrop.new(self),
      'tag' => "<img src=\"#{self.file.png.thumb('640x480#').url}\" alt=\"#{self.title}\" />"
    }
  end
end
