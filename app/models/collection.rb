class Collection < ActiveRecord::Base
  attr_accessible :description, :name, :setup_id
  
  belongs_to :setup
  
  has_many :catalogs_collections, uniq: true
  has_many :catalogs, :through => :catalogs_collections

  validates_presence_of :name
  liquid_methods :name, :id
  
  default_scope order('name ASC')
end
