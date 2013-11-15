class Setup < ActiveRecord::Base
  acts_as_nested_set
  
  attr_accessible :logo_uid, :primary_color, :title, :by_line, :contact_email, 
        :default_invite, :urls_attributes, :analytics_account, :twitter_url, :github_url, :facebook_url, :parent_id, :acronym, :description, :keywords, :projection, :google_layers, :record_projection, :google_plus_url, :youtube_url, :instagram_url, :linkedin_url, :favicon_attributes
  
  has_and_belongs_to_many :images
  
  # has_and_belongs_to_many :pages, class_name: 'Page::Content', join_table: 'pages_setups'
  # has_and_belongs_to_many :layouts, class_name: 'Page::Layout', join_table: 'page_layouts_setups'
  # has_and_belongs_to_many :snippets, class_name: 'Page::Snippet'
  
  has_many :pages, class_name: 'Page::Content'
  has_many :layouts, class_name: 'Page::Layout'
  has_many :snippets, class_name: 'Page::Snippet'
  
  has_and_belongs_to_many :persons, join_table: 'persons_setups', uniq: true
  has_and_belongs_to_many :agencies, join_table: 'agencies_setups', uniq: true


  has_many :catalogs_setups, uniq: true, dependent: :destroy
  has_many :catalogs, through: :catalogs_setups
  has_many :owned_catalogs, class_name: 'Catalog', foreign_key: 'catalogs'
#  has_and_belongs_to_many :catalogs
  
  has_many :catalog_collections, dependent: :destroy
  has_many :collections
  has_many :contacts
  has_many :urls, class_name: 'SiteUrl', dependent: :destroy, order: "id ASC"
  has_many :memberships, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :use_agreements, dependent: :destroy
  has_many :csw_imports, dependent: :destroy
  
  belongs_to :theme
  has_many :themes, foreign_key: 'owner_setup_id'
  has_one :favicon, dependent: :destroy
  
  accepts_nested_attributes_for :urls, reject_if: proc { |url| url['url'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :favicon, allow_destroy: true

  def to_liquid
  	{ 
  		'title' => self.title,
  		'by_line' => self.by_line,
      'contact_email' => self.contact_email, 
  		'collections' => self.collections,
      'page' => SetupSubpageDrop.new(self),
      'catalog' => SetupCatalogRecordsDrop.new(self),
      'twitter_url' => self.twitter_url,
      'github_url' => self.github_url,
      'facebook_url' => self.facebook_url,
      'google_plus_url' => self.google_plus_url,
      'youtube_url' => self.youtube_url, 
      'instagram_url' => self.instagram_url,
      'linkedin_url' => self.linkedin_url
  	}
  end
  
  def default_url
    self.urls.where(default: true).first.try(:url) || self.urls.first.try(:url)
  end
  
  def clone(source = nil)
    return nil if source.nil?
    
    @layout_map = {}
    source.layouts.each do |l|
      layout = l.dup
      self.layouts << layout
      # layout.save!
      @layout_map[l.id] = layout
    end
    
    source.snippets.each do |p|
      snippet = p.dup
      # snippet.setup = self
      # snippet.save!
      self.snippets << snippet
    end
    
    source.pages.roots.each do |p|
      self.clone_page(p, nil, @layout_map)
    end
    
    source.roles.each do |r|
      role = r.dup
      # role.setup = self
      # role.save!
      self.roles << role
    end
    
    self.theme = source.theme.dup
  end
  alias_method :clone=, :clone
  
  def clone_page(page, parent_page, layouts)
    new_page = page.dup
    new_page.page_layout = layouts[page.page_layout_id]
    new_page.parent = parent_page
    self.pages << new_page
    
    page.children.each do |child_page|
      self.clone_page(child_page, new_page, layouts)
    end
  end
  
  def full_title
    "#{self.title} :: #{self.by_line}"
  end
  
  def self.clone(setup, site = {})
    raise 'Need default url for the new setup' unless site.include? :default_url
    
    new_site = Setup.new(title: site[:title], by_line: site[:by_line])
    new_site.urls.build(url: site[:default_url])
    new_site.save!
    new_site.clone_from(setup)
    
    new_site
  end
end
