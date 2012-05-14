class CdnClone
  @queue = :cdn
  
  def self.perform(repohex, branch = "master")
    repo = Repo.where('repohex = ?', repohex).first
    clone = repo.clone_to(NSCatalog::Application.config.repo_clones)
    puts clone.inspect
    clone.pull
  end
end