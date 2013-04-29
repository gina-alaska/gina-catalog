class Setup < ActiveRecord::Base
  acts_as_nested_set
  
  attr_accessible :logo_uid, :primary_color, :title, :by_line, :contact_email, 
        :default_invite, :urls_attributes, :analytics_account, :twitter_url, :github_url, :facebook_url,
        :parent_id
  
  has_and_belongs_to_many :images
  has_and_belongs_to_many :pages, class_name: 'Page::Content', join_table: 'pages_setups'
  has_and_belongs_to_many :layouts, class_name: 'Page::Layout', join_table: 'page_layouts_setups'
  has_and_belongs_to_many :snippets, class_name: 'Page::Snippet'
  has_and_belongs_to_many :persons, join_table: 'persons_setups'
  has_and_belongs_to_many :agencies, join_table: 'agencies_setups'


  has_many :catalogs_setups, uniq: true
  has_many :catalogs, through: :catalogs_setups
  has_many :owned_catalogs, class_name: 'Catalog', foreign_key: 'catalogs'
#  has_and_belongs_to_many :catalogs
  
  has_many :catalog_collections
  has_many :collections
  has_many :contacts
  has_many :urls, class_name: 'SiteUrl', dependent: :destroy
  has_many :memberships
  has_many :roles
  has_many :use_agreements
  
  belongs_to :theme
  has_many :themes, foreign_key: 'owner_setup_id'
  
  accepts_nested_attributes_for :urls, reject_if: proc { |url| url['url'].blank? }, allow_destroy: true

  def to_liquid
  	{ 
  		'title' => self.title,
  		'by_line' => self.by_line,
  		'collections' => self.collections,
      'page' => SetupSubpageDrop.new(self),
      'twitter_url' => self.twitter_url,
      'github_url' => self.github_url,
      'facebook_url' => self.facebook_url
  	}
  end
  
  def self.clone_from(setup, site = {})
    raise 'Need default url for the new setup' unless site.include? :default_url
    
    new_site = Setup.new(title: site[:title], by_line: site[:by_line])
    new_site.urls.build(url: site[:default_url])
    new_site.save!
    
    @layout_map = {}
    setup.layouts.each do |l|
      layout = l.dup
      layout.save!
      new_site.layouts << layout
      @layout_map[l.id] = layout
    end
    
    setup.snippets.each do |p|
      snippet = p.dup
      snippet.save!
      new_site.snippets << snippet
    end
    
    setup.pages.roots.each do |p|
      page = p.dup
      page.page_layout = @layout_map[p.page_layout.id]
      page.save!      
      new_site.pages << page
    end
    
    setup.roles.each do |r|
      role = r.dup
      r.save!
      new_site.roles << r
    end
    
    new_site
  end
end
