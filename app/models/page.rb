require 'html/pipeline'

class Page < ActiveRecord::Base
  attr_accessible :content, :layout, :slug, :title, :sections, :page_layout_id, :page_layout
  
  serialize :sections
  serialize :content
  
  has_and_belongs_to_many :setups
  belongs_to :page_layout
  
  liquid_methods :title, :slug
  
  def to_param
    self.slug
  end
  
  def sections
    s = super
    s = ['body'] if s.nil? or s.empty?
    
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
    context = { :page => self }
    
    pipeline = HTML::Pipeline.new([ ::LiquidFilter ], context)
    
    pipeline.call(self.content[section.to_s])[:output].to_s.html_safe
  end
  
  def to_liquid
    {
      'title' => self.title,
      'slug' => self.slug,
      'content' => ::PageContentDrop.new(self)
    }
  end
end
