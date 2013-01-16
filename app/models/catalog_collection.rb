class CatalogCollection < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :catalogs

  validates_presence_of :name
end
