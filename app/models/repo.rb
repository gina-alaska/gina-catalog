class Repo < ActiveRecord::Base
  belongs_to :catalog
  
  validates_uniqueness_of :repohex
  validates_uniqueness_of :slug

  after_create :init

  def exists?
    File.directory?(self.path)
  end
  
  def slug
    if read_attribute(:slug).nil?
      write_attribute(:slug, self.repohex)
    end
    read_attribute(:slug)
  end

  def repohex
    if read_attribute(:repohex).nil?
      hex = self.generate_hex
      while File.directory? self.path(hex)
        hex = self.generate_hex
      end
      write_attribute(:repohex, hex)
    end

    super
  end
  
  def path(hex = self.repohex)
    oldpath = File.join(NSCatalog::Application.config.repos_path, "#{hex}.git")
    if File.directory?(oldpath)
      return oldpath
    else
      subdir = hex[0..1]
      return File.join(NSCatalog::Application.config.repos_path, subdir, "#{hex}.git")
    end
  end

  def readme_template
    <<-EOF
Title: #{self.catalog.title}
Description: #{self.catalog.description}
    EOF
  end  
  
  def empty?
    !File.exists?(self.path) || self.files.count <= 1
  end

  def files
    if File.exists?(self.path)
      RepoFilelist.new(grit).tree.sort_by{ |file| file[:name].downcase }
    else
      []
    end
  end
  
  def grit
    @grit ||= Grit::Repo.new(self.path)
  end
    
  def init
    @grit = Grit::Repo.init_bare_or_open(self.path)
    update_hooks
    
    create_file('README', readme_template, 'Creating README file')
  end
  
  def create_file(file, contents, msg)
    index = grit.index
    index.read_tree(grit.tree.id)
    index.add(file, contents)
    index.commit(msg, grit.commits)
  end
  
  def clone_path=(path)
    @clone_path = path
  end
  
  def clone_path
    @clone_path ||= File.join(NSCatalog::Application.config.repos_tmp, self.repohex)
  end
  
  def cloned?
    !@cloned.nil?
  end
  
  def clone_to(path)
    cpath = File.join(path, self.repohex)
    
    unless File.exists?(File.join(cpath, '.git'))
      git = Grit::Git.new(path)
      self.clone_path = cpath
      git.clone({ :quiet => false, :timeout => false}, self.path, self.clone_path)
    end
    
    Grit::Git.new(File.join(self.clone_path, '.git'))
  end
  
  def clone_repo(opts = {}, &block)
    # If the repo is already cloned we don't want to do the auto stuff
    # Example:
    # repo.clone { |proxy| proxy.add('file.txt', :to => 'foo') }
  
    if !cloned? and opts[:auto] != false
      opts[:autopush] = true unless opts.include? :autopush
      opts[:autoclean] = true unless opts.include? :autoclean
  
      #Only affects files already in the repo
      opts[:autocommit] = true unless opts.include? :autocommit
    end
  
    Rails.logger.info "Cloning to temp repo @ #{NSCatalog::Application.config.repos_tmp}"
    @cloned ||= self.clone_to(NSCatalog::Application.config.repos_tmp)
    
    if block_given?
      Dir.chdir(self.clone_path) do
        yield(self, @cloned)
  
        if opts[:autocommit]
          @cloned.commit({ :timeout => false, :a => true, :m => @commit_msgs.join("\n") })
          @commit_msgs = []
          @cloned.push({ :timeout => false }) if opts[:autopush]
        end
      end
      cleanup if opts[:autoclean]
    end
  end
  
  def add(files, opts = {})
    opts[:to] = self.clone_path unless opts.include? :to
    files = [files] unless files.is_a? Array
  
    @commit_msgs = []
    clone_repo do |repo, git|
      Rails.logger.info "Clone repo #{repo.inspect}"
      files.each do |f|
        if f.original_filename
          filename = f.original_filename
        else
          filename = File.basename(f)
        end
        destination = File.join(opts[:to], filename)
        
        FileUtils.mkdir_p(File.dirname(destination))
        
        if f.tempfile
          Rails.logger.info "copying #{f.tempfile} to #{destination}"
          FileUtils.cp(f.tempfile, destination)
        else
          FileUtils.cp(f, destination)
        end
        
        git.add({ :timeout => false }, destination)
        @commit_msgs << "Adding #{filename} to #{opts[:to].gsub(repo.clone_path, "#{repo.repohex}/")}"
      end
    end
    @commit_msgs
  end
  
  ## ARCHIVE
  def update_hooks
    cmd = ['ln -sf', File.join(NSCatalog::Application.config.deploy_path, 'hooks/post-receive'), "#{path}/hooks/post-receive"]
    `#{cmd.join(' ')}`
  end
  
  def async_create_archive(branch = 'master')
    Resque.enqueue(Archive, self.repohex, branch)
  end
  
  def async_update_cdn_clone(branch = 'master')
    Resque.enqueue(CdnClone, self.repohex, branch)
  end
  
  def archive_filenames
    # dest = NSCatalog::Application.config.archive_path
    # { 
    #   :zip => File.join(dest, "#{self.catalog.to_param}.zip"), 
    #   :tar_gz => File.join(dest, "#{self.catalog.to_param}.tar.gz")
    # }
    { :zip => self.find_archive || self.default_archive_filename }
  end
  
  def default_archive_filename
    File.join(NSCatalog::Application.config.archive_path, "#{self.catalog.to_param}.zip")
  end
  
  def find_archive
    if File.exists?(default_archive_filename)
      default_archive_filename
    else
      Dir.glob(File.join(NSCatalog::Application.config.archive_path, "#{self.catalog.id}-*.zip")).first 
    end
  end
  
  def archive_available?(format = :zip)
    File.exists?(archive_filenames[format])
  end
  
  def create_archive(treeish, opts={})
    opts[:prefix] ||= "#{self.catalog.to_param}/"
    
    FileUtils.mkdir_p(File.dirname(archive_filenames[:zip]))
    
    FileUtils.rm(self.archive_filenames[:zip]) if self.archive_available?
      
    File.open(default_archive_filename, 'wb') do |fp|
      fp << archive_zip(treeish, opts[:prefix])
    end
      
    # don't make tar.gz for now
    # File.open(archive_filenames[:tar_gz], 'wb') do |fp|
    #   fp << archive_tar_gz(treeish, opts[:prefix])
    # end
  end

  def archive_tar_gz(treeish, prefix = nil)
    return grit.archive_tar_gz(treeish, prefix)
  end
  
  def archive_zip(treeish, prefix = nil)
    options = {}
    options[:format] = 'zip'
    options[:prefix] = prefix unless prefix.nil?
    return grit.git.archive({ :format => 'zip', :prefix => prefix }, treeish)
  end  
  ##
  
  def to_param
    self.slug
  end
  
  # Remove any cloned repos if they exist
  def cleanup
    FileUtils.rm_r(self.clone_path) if File.directory?(self.clone_path)
    @cloned = nil
  end
  
  def to_json(opts=nil)
    files.to_json(opts)
  end
  
  def generate_hex
    SecureRandom.hex(4)
  end
end
