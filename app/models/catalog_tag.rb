class CatalogTag < ActiveRecord::Base
  belongs_to :catalog
  belongs_to :tag
end
