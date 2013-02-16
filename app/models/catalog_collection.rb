class CatalogCollection < ActiveRecord::Base
  attr_accessible :description, :name

  belongs_to :setup
  has_and_belongs_to_many :catalogs

  validates_presence_of :name

  liquid_methods :name, :id
end
