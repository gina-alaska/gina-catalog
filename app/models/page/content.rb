require 'html/pipeline'

class Page::Content < ActiveRecord::Base
  attr_accessible :content, :layout, :slug, :title, :sections, :page_layout_id, :page_layout, :parent_id, :redirect, :description, :main_menu, :menu_icon, :draft, :updated_by_id, :system_page, :lock_version

  acts_as_nested_set
  before_save :rebuild_slug
  
  # this needs to be included after the rebuild slug to make sure we check for the change 
  # correctly
  include CatalogConcerns::SystemContent
  
  serialize :sections
  serialize :content
  
  # this will need to be removed in a future update
  # has_and_belongs_to_many :setups, join_table: 'pages_setups'
  belongs_to :setup
  
  has_many :page_images, class_name: 'Page::Image'
  has_many :images, :through => :page_images
  
  belongs_to :page_layout, class_name: 'Page::Layout'
  belongs_to :updated_by, class_name: 'User'
  
  accepts_nested_attributes_for :images
  
  validates_presence_of :slug
  validates_uniqueness_of :slug, scope: [:parent_id, :setup_id]
  validates_presence_of :title
  validates_length_of :description, maximum: 255
  
  liquid_methods :title, :slug, :images
  
  # def to_param
  #   self.slug
  # end
  
  scope :public, where(draft: false)
  scope :autolinkable, -> { where({ draft: false, main_menu: true }) }
  scope :contact, where(slug: "contacts")
  scope :sitemap, where(slug: "sitemap")

  def rebuild_slug
    parent_slugs = self.ancestors.collect { |p| p.slug.split('/').last } << self.slug_without_path
    self.slug = parent_slugs.join('/')
  end

  def slug_without_path
    self.read_attribute(:slug).try(:split, '/').try(:last)
  end
  
  def slug_with_root
    if self.slug[0] != ?/
      "/#{self.slug}" 
    else
      self.slug
    end
  end
  
  def sections
    s = super
    
    s = ['body'] if s.nil? or s.empty?
    s << 'images' unless s.include?('images')
    
    s
  end

  def public?
    !self.draft
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
    ::CmsRenderers.content_section(self, self.setup, self.content[section])
  end
  
  def to_liquid
    {
      'title' => self.title,
      'slug' => self.slug,
      'domid' => self.slug.downcase.gsub(/[\/\s]/, '_'),
      'content' => ::PageContentDrop.new(self),
      'description' => self.description,
      'images' => self.images,
      'root' => self.root,
      'parent' => self.parent,
      'children' => self.children.public,
      'public' => self.public?,
      'show_in_menu' => self.main_menu,
      'last_editor' => self.updated_by.fullname,
      'created_at' => self.created_at,
      'updated_at' => self.updated_at
    }
  end
end
