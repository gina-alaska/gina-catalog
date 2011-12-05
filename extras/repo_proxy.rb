class RepoProxy
  attr_accessor :parent
  attr_accessor :child_klass
  attr_accessor :repo

  def initialize(p, opts = {})
    @commit_msgs = []
    @parent = p
    
    @relation = {
      :child_klass => opts[:class_name].constantize,
      :foreign_key => opts.include?(:foreign_key) ? opts[:foreign_key] : 'repohex',
      :readme_template => opts.include?(:readme_template) ? opts[:readme_template] : 'readme_template'
    }

    create_repo unless repo_exists?
    @repo ||= Grit::Repo.new(repo_path)
  end

  def repo
    @repo
  end
  
  def empty?
    files.count <= 1
  end

  def files
    RepoFilelist.new(repo).tree
  end

  def repo_name
    parent.send(@relation[:foreign_key])
  end

  def self.repo_path(hex)
    File.join(NSCatalog::Application.config.repos_path, "#{hex}.git")
  end

  def repo_path
    RepoProxy::repo_path(repo_name)
  end

  def repo_exists?
    File.directory? repo_path
  end

  def archive(treeish, prefix = nil)
    old_max = Grit::Git.git_max_size
    Grit::Git.git_max_size = 100.megabytes
    Grit::Git.git_timeout = 3000

    return repo.archive_tar_gz(treeish, prefix)
  end

  def create_repo
    @repo = Grit::Repo.init_bare_or_open(repo_path)
    create_file('README', parent.send(@relation[:readme_template]), 'Creating README file')
  end

  def create_file(file, contents, msg)
    index = @repo.index
    index.read_tree(@repo.tree.id)
    index.add(file, contents)
    index.commit(msg, @repo.commits)
  end
  
  def clone_path
    File.join(NSCatalog::Application.config.repos_tmp, repo_name)
  end

  def clone(opts = {}, &block)
    # If the repo is already cloned we don't want to do the auto stuff
    # Example:
    # repo.clone { |proxy| proxy.add('file.txt', :to => 'foo') }

    if !cloned? and opts[:auto] != false
      opts[:autopush] = true unless opts.include? :autopush
      opts[:autoclean] = true unless opts.include? :autoclean

      #Only affects files already in the repo
      opts[:autocommit] = true unless opts.include? :autocommit
    end

    grit = Grit::Git.new(NSCatalog::Application.config.repos_tmp)
    grit.clone({:quiet => true, :timeout => false}, repo_path, clone_path) unless cloned?
    @cloned = true

    if block_given?
      Dir.chdir(clone_path) do
        cloned_repo = Grit::Git.new(File.join(clone_path, '.git'))

        yield(self, cloned_repo)

        if opts[:autocommit]
          cloned_repo.commit({ :timeout => false, :a => true, :m => @commit_msgs.join("\n") })
          @commit_msgs = []
          cloned_repo.push({ :timeout => false }) if opts[:autopush]
        end
      end
      cleanup if opts[:autoclean]
    end
  end

  def add(files, opts = {})
    opts[:to] = clone_path unless opts.include? :to
    files = [files] unless files.is_a? Array

    clone do |proxy, git|
      files.each do |f|
        filename = File.join(opts[:to], File.basename(f))

        FileUtils.mkdir_p(File.dirname(filename))
        FileUtils.cp(f, filename)

        git.add({ :timeout => false }, filename)
        @commit_msgs << "Adding #{File.basename(filename)} to #{opts[:to].gsub(clone_path, "#{repo_name}/")}"
      end
    end
  end

  # Remove any cloned repos if they exist
  def cleanup
    FileUtils.rm_r(clone_path) if File.directory?(clone_path)
    @cloned = nil
  end

  def to_json(opts=nil)
    files.to_json(opts)
  end

  def self.generate_hex
    SecureRandom.hex(4)
  end

  protected

  def cloned?
    !!@cloned
  end
  
end
