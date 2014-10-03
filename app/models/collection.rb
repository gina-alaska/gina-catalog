class Collection < ActiveRecord::Base
  attr_accessible :description, :name, :setup_id, :hidden
  
  belongs_to :setup, touch: true
  
  has_many :catalogs_collections, uniq: true
  has_many :catalogs, :through => :catalogs_collections, uniq: true

  has_and_belongs_to_many :csw_imports
  
  
  validates_presence_of :name
  validates :name, length: { maximum: 255 }
  
  scope :including_descendants, ->(setup) {
    where(setup_id: setup.self_and_descendants.pluck(:id))
  }
  
  scope :visible_to, ->(member = nil) {
    where(hidden: false) unless member.try(:access_catalog?)
  }  

  def to_liquid
    {
      'name' => self.name,
      'id' => self.id,
      'records' => self.catalogs
    }
  end
end
