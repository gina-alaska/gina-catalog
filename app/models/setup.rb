class Setup < ActiveRecord::Base
  attr_accessible :logo_uid, :primary_color, :title, :by_line, :contact_email
  
  has_and_belongs_to_many :images
  has_and_belongs_to_many :pages, class_name: 'Page::Content', join_table: 'pages_setups'
  has_and_belongs_to_many :layouts, class_name: 'Page::Layout', join_table: 'page_layouts_setups'
  has_and_belongs_to_many :snippets, class_name: 'Page::Snippet'
  has_and_belongs_to_many :catalogs
  
  has_many :catalog_collections
  has_many :contacts
  
  has_many :urls, class_name: 'SiteUrl', dependent: :destroy
  
  liquid_methods :title, :by_line, :catalog_collections

  def to_liquid
  	{ 
  		'title' => self.title,
  		'by_line' => self.by_line,
  		'catalog_collections' => self.catalog_collections
  	}
  end
end
