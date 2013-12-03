module CatalogConcerns
  module Upload
    extend ActiveSupport::Concern
    
    def upload_path
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
      @files = Dir.entries(self.upload_path).reject { |f| f[0] == ?. or file == 'README' } if File.directory? self.upload_path
      @files ||= []      
    end
    
    def convert_repo
      self.repo.clone_repo({ autocommit: false }) do |r|
        repo_files = Dir.entries('.').reject { |f| f[0] == ?. }
        puts repo_files.inspect
        next if repo_files.empty?
        
        FileUtils.mkdir_p(upload_path)
        FileUtils.cp(repo_files, upload_path)
      end
    end
    
    def async_create_archive_file
      Resque.enqueue(Archive, self.id)
    end
    
    def create_archive_file
      # don't create archives with no files in them
      return if self.files.empty?
        
      FileUtils.mkdir_p(File.dirname(archive_file))
      FileUtils.rm(archive_file) if archive_exists?
      
      ::Zip::File.open(archive_file, ::Zip::File::CREATE) do |zipfile|
          Dir[File.join(upload_path, '**', '**')].each do |file|
            zipfile.add(file.sub(File.dirname(upload_path) + '/', ''), file)
          end
      end
    end
    
    def handle_uploaded_file(tmpfile)
      destination = File.join(upload_path, tmpfile.original_filename)
      return false if File.exists?(destination)
      
      #make sure the destination exists
      FileUtils.mkdir_p(upload_path)
      FileUtils.cp(tmpfile.path, destination)
      
      async_create_archive_file
      
      return true
    end
  end
end