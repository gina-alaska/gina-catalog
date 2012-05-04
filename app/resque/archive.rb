class Archive
  @queue = :file_serve
  
  def self.perform(repohex, branch = "master")
    repo = Repo.where('repohex = ?', repohex).first
    repo.create_archive(branch)
  end
end