class CatalogsContact < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :catalog
  belongs_to :contact, class_name: 'Person', foreign_key: 'person_id'

  after_save :reindex_catalog
  after_destroy :reindex_catalog

  def reindex_catalog
    self.catalog.index
  end
end
