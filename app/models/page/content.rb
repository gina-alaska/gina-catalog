require 'html/pipeline'

class Page::Content < ActiveRecord::Base
  ICONS = ["icon-home","icon-file","icon-map-marker","icon-user","icon-info-sign","icon-question-sign","icon-envelope","icon-search","icon-star","icon-star-empty","icon-ok","icon-remove","icon-flag","icon-book","icon-bookmark","icon-print","icon-camera","icon-list","icon-picture","icon-exclamation-sign","icon-gift","icon-leaf","icon-fire","icon-calendar","icon-folder-close","icon-folder-open","icon-globe","icon-wrench","icon-briefcase"]

  attr_accessible :content, :layout, :slug, :title, :sections, :page_layout_id, :page_layout, :parent_id, :redirect, :description, :main_menu, :menu_icon
  
  acts_as_nested_set
  before_save :rebuild_slug
  
  serialize :sections
  serialize :content
  
  has_and_belongs_to_many :setups, join_table: 'pages_setups'
  has_many :page_images, class_name: 'Page::Image'
  has_many :images, :through => :page_images
  
  belongs_to :page_layout, class_name: 'Page::Layout'
  
  accepts_nested_attributes_for :images
  
  validates_presence_of :slug
  validates_presence_of :title
  validates_length_of :description, maximum: 255
  
  liquid_methods :title, :slug, :images
  
  # def to_param
  #   self.slug
  # end
  
  def rebuild_slug
    parent_slugs = self.ancestors.collect { |p| p.slug.split('/').last } << self.slug_without_path
    self.slug = parent_slugs.join('/')
  end
  
  def slug_without_path
    self.read_attribute(:slug).try(:split, '/').try(:last)
  end
  
  def sections
    s = super
    
    s = ['body'] if s.nil? or s.empty?
    s << 'images' unless s.include?('images')
    
    s
  end
  
  def layout
    self.page_layout.content
  end
  
  def content
    c = super
    self.sections.each { |k|
      c ||= {}
      c[k] ||= ''
    }
      
    c 
  end
  
  def content_for(section)
    context = { :page => self, :setup => self.setups.first }
    
    pipeline = HTML::Pipeline.new([ ::LiquidFilter ], context)
    pipeline.call(self.content[section.to_s])[:output].to_s.html_safe
  end
  
  def to_liquid
    {
      'title' => self.title,
      'slug' => self.slug,
      'content' => ::PageContentDrop.new(self),
      'description' => self.description,
      'images' => self.images,
      'children' => self.children
    }
  end
end
