class AssetRepo
  include Grit

  attr_accessor :repohex

  def self.find(key)
    AssetRepo.new(key)
  end

  def initialize(key)
    repohex = key

    create_repo(path) unless File.directory? path
    repo = Grid::Repo.new(path)
  end

  def path
    raise "Unable to find repo path, missing repo hex" if repohex.nil?
    RepoFinder.path(repohex)
  end

  def repo
    @repo
  end

  def repo=(v)
    @repo = v
  end

  def asset
    @asset ||= Asset.find_by_repohex(repohex)
    @asset
  end

  def create_repo(directory)
    repo = Grit::Repo.init(directory)

    Dir.chdir(repo.working_dir) do
      File.open('README', 'w') do |fp|
        fp << "Template README for the Asset Information"
      end

      repo.add('README')
      repo.commit_index("Creating initial repo for asset #{asset.title}")
    end
  end
end
