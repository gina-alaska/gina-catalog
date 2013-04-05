class Setup < ActiveRecord::Base
  attr_accessible :logo_uid, :primary_color, :title, :by_line, :contact_email, 
        :default_invite, :urls_attributes, :analytics_account, :twitter_url, :github_url, :facebook_url
  
  has_and_belongs_to_many :images
  has_and_belongs_to_many :pages, class_name: 'Page::Content', join_table: 'pages_setups'
  has_and_belongs_to_many :layouts, class_name: 'Page::Layout', join_table: 'page_layouts_setups'
  has_and_belongs_to_many :snippets, class_name: 'Page::Snippet'
  has_and_belongs_to_many :catalogs
  has_and_belongs_to_many :persons, join_table: 'persons_setups'
  has_and_belongs_to_many :agencies, join_table: 'agencies_setups'
  
  has_many :catalog_collections
  has_many :contacts
  has_many :urls, class_name: 'SiteUrl', dependent: :destroy
  has_many :memberships
  has_many :roles
  
  accepts_nested_attributes_for :urls, reject_if: proc { |url| url['url'].blank? }, allow_destroy: true

  liquid_methods :title, :by_line, :catalog_collections

  def to_liquid
  	{ 
  		'title' => self.title,
  		'by_line' => self.by_line,
  		'catalog_collections' => self.catalog_collections,
      'page' => SetupSubpageDrop.new(self),
      'twitter_url' => self.twitter_url
  	}
  end
end
