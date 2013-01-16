class CatalogCollection < ActiveRecord::Base
  attr_accessible :description, :name

  belongs_to :setup
  has_many :catalogs

  validates_presence_of :name
end
