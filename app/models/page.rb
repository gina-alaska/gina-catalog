class Page < ActiveRecord::Base
  attr_accessible :content, :layout, :slug, :title, :sections
  serialize :sections
  serialize :content
  
  has_and_belongs_to_many :setups
  
  def to_param
    self.slug
  end
  
  def sections
    s = super
    s = ['body'] if s.nil? or s.empty?
    
    s
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
    self.content[section.to_s].try(:html_safe)
  end
end
