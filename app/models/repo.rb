class Repo < ActiveRecord::Base
  belongs_to :catalog
  
  validates_uniqueness_of :repohex
  validates_uniqueness_of :slug

  before_create :init

  def exists?
    File.directory?(self.path)
  end

  def repohex
    if read_attribute(:repohex).nil?
      hex = self.generate_hex
      while File.directory? self.path
        hex = self.generate_hex
      end
      write_attribute(:repohex, hex)
    end

    super
  end
  
  def path
    File.join(NSCatalog::Application.config.repos_path, "#{repohex}.git")
  end

  def readme_template
    <<-EOF
Title: #{self.catalog.title}
    EOF
  end  
  
  def grit
    @grit ||= Grit::Repo.new(self.path)
  end
    
  def init
    @grit = Grit::Repo.init_bare_or_open(self.path)
    create_file('README', readme_template, 'Creating README file')
  end
  
  def create_file(file, contents, msg)
    index = grit.index
    index.read_tree(grit.tree.id)
    index.add(file, contents)
    index.commit(msg, grit.commits)
  end
  
  def clone_path
    File.join(NSCatalog::Application.config.repos_tmp, self.repohex)
  end
  
  def cloned?
    !@cloned.nil?
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
  
    unless cloned?
      git = Grit::Git.new(NSCatalog::Application.config.repos_tmp)
      git.clone({:quiet => true, :timeout => false}, self.path, self.clone_path)
      @cloned = Grit::Git.new(File.join(self.clone_path, '.git'))
    end
    
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
  
    clone_repo do |repo, git|
      files.each do |f|
        filename = File.join(opts[:to], File.basename(f))
  
        FileUtils.mkdir_p(File.dirname(filename))
        FileUtils.cp(f, filename)
  
        git.add({ :timeout => false }, filename)
        @commit_msgs << "Adding #{File.basename(filename)} to #{opts[:to].gsub(repo.clone_path, "#{repo.hex}/")}"
      end
    end
  end
  
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
