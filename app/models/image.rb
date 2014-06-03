class Image < ActiveRecord::Base
  attr_accessible :description, :file_uid, :link_to_url, :title, :file, :setups
  dragonfly_accessor :file
  
  has_and_belongs_to_many :setups
  has_many :page_images, class_name: 'Page::Image'
  has_many :pages, :through => :page_images, class_name: 'Page::Content'
  has_many :agencies
  
  def to_param
    "#{self.id}-#{File.basename(self.file.name.to_s, '.*')}"
  end
  
  def raw_url
    self.file.remote_url
  end
  
  def link_to_url_or_raw_url
    self.link_to_url.empty? ? self.raw_url : self.link_to_url
  end
  
  alias_method :url, :raw_url
  alias_method :image_url, :raw_url
  
  def thumbnail(size = '640x480#')
  #   if self.file.try(:image?) and self.file_stored? and !%w{ pdf kmz kml }.include?(self.file.format)
  #     self.file.thumb(size).encode(:png)
  #   else
  #     Image.document_image
  #   end
  # rescue Dragonfly::Job::Fetch::NotFound
  #   Image.document_image    
  # end
  
    OpenStruct.new({ url: helpers.cms_media_path(self.file_uid, size: size) })
  end

  def helpers
    Rails.application.routes.url_helpers
  end
  
  def self.document_image
    OpenStruct.new(url: ActionController::Base.helpers.asset_path('document.png'))
  end
  
  def to_liquid
    {
      'title' => self.title,
      'description' => self.description,
      'link_to_url' => self.link_to_url_or_raw_url,
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
