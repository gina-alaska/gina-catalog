require 'html/pipeline'

class Page < ActiveRecord::Base
  attr_accessible :content, :layout, :slug, :title, :sections, :page_layout_id, :page_layout, :parent_id, :redirect
  
  acts_as_nested_set
  before_save :rebuild_slug
  
  serialize :sections
  serialize :content
  
  has_and_belongs_to_many :setups
  has_many :page_images
  has_many :images, :through => :page_images
  
  belongs_to :page_layout
  
  accepts_nested_attributes_for :images
  
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
      'images' => self.images
    }
  end
end
