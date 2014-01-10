class Collection < ActiveRecord::Base
  attr_accessible :description, :name, :setup_id, :hidden
  
  belongs_to :setup
  
  has_many :catalogs_collections, uniq: true
  has_many :catalogs, :through => :catalogs_collections, uniq: true

  has_and_belongs_to_many :csw_imports
  
  
  validates_presence_of :name
  validates :name, length: { maximum: 255 }
  liquid_methods :name, :id  
  
  scope :including_descendents, ->(setup) {
    where(setup_id: setup.self_and_descendants.pluck(:id))
    where(hidden: false)
  }
  
  
end
