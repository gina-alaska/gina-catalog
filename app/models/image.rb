class Image < ActiveRecord::Base
  attr_accessible :description, :file_uid, :link_to_url, :title, :file, :setups
  image_accessor :file
  
  has_and_belongs_to_many :setups
  has_many :page_images, class_name: 'Page::Image'
  has_many :pages, :through => :page_images, class_name: 'Page::Content'
  has_many :agencies
  
  def raw_url
    self.file.url
  end
  
  def link_to_url_or_raw_url
    self.link_to_url.empty? ? self.link_to_url : self.raw_url
  end
  
  alias_method :url, :raw_url
  alias_method :image_url, :raw_url
  
  def thumbnail(size = '640x480#')
    self.file.image? ? self.file.process(:page, 0).thumb(size).png : nil
  rescue Dragonfly::DataStorage::DataNotFound => e
    nil
  end
  
  def to_liquid
    {
      'title' => self.title,
      'description' => self.description,
      'link_to_url' => self.raw_url,
      'thumb' => ::ImageTagDrop.new(self),
      'grayscale' => ::ProcessImageTagDrop.new(self, :grayscale),
      'tag' => "<img src=\"#{self.thumbnail.try(:url)}\" alt=\"#{self.title}\" />"
    }
  end

  searchable do
    text :title, boost: 2.0
    text :description
    text :file_name
  end
end
