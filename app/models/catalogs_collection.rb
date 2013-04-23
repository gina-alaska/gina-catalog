class CatalogsCollection < ActiveRecord::Base
  attr_accessible :catalog_id, :collection_id
  
  belongs_to :catalog, touch: true
  belongs_to :collection
  
  after_save :reindex_catalog
  after_destroy :reindex_catalog

  def reindex_catalog
    catalog.index
  end
end
