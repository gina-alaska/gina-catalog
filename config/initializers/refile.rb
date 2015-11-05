if Rails.env.production?
  # do stuff for s3!
else
  require 'glynx/refile/file_system'
  require 'glynx/refile/hasher'

  # turn off automounter so we can do it ourselves before the cms page slug glob
  Refile.cache = Glynx::Refile::FileSystem.new("tmp/uploads/cache", max_size: 50.megabytes, hasher: Glynx::Refile::DateHasher.new)
  Refile.store = Glynx::Refile::FileSystem.new("uploads/cms", hasher: Glynx::Refile::DateHasher.new)
end

Refile.automount = false
