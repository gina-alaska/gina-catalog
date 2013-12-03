module CatalogConcerns
  module Upload
    extend ActiveSupport::Concern
    
    def storage_path
      File.join(Rails.configuration.catalog_uploads_path, 'catalog', self.to_param)
    end
    
    def archive_path
      Rails.configuration.archive_path
    end
    
    def archive_file
      File.join(archive_path, 'catalog', self.id.to_s[0..1], self.to_param + '.zip')
    end
    
    def archive_size
      File.size(archive_file)
    end
    
    def archive_exists?
      File.exists? archive_file
    end
    
    def files
      @files = Dir.entries(self.storage_path).reject { |f| f[0] == ?. } if File.directory? self.storage_path
      @files ||= []      
    end
    
    def async_create_archive_file
      Resque.enqueue(Archive, self.id)
    end
    
    def create_archive_file
      FileUtils.mkdir_p(File.dirname(archive_file))
      FileUtils.rm(archive_file) if archive_exists?
      
      ::Zip::File.open(archive_file, ::Zip::File::CREATE) do |zipfile|
          Dir[File.join(storage_path, '**', '**')].each do |file|
            zipfile.add(file.sub(File.dirname(storage_path) + '/', ''), file)
          end
      end
    end
    
    def handle_uploaded_file(tmpfile)
      destination = File.join(storage_path, tmpfile.original_filename)
      return false if File.exists?(destination)
      
      #make sure the destination exists
      FileUtils.mkdir_p(storage_path)
      FileUtils.cp(tmpfile.path, destination)
      
      async_create_archive_file
      
      return true
    end
  end
end