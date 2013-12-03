class Archive
  @queue = :file_serve
  
  def self.perform(catalog_id)
    catalog = Catalog.find(catalog_id)
    catalog.create_archive_file
  end
end