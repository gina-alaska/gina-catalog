class CatalogsSetup < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :catalog, touch: true
  belongs_to :setup, touch: true
  
  after_save :reindex_catalog
  after_destroy :reindex_catalog

  def reindex_catalog
    catalog.index!
  end
end
