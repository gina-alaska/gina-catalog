if Rails.env.development?
  require 'glynx/refile/file_system'
  require 'glynx/refile/hasher'
  Refile.cache = Glynx::Refile::FileSystem.new("tmp/uploads/cache", max_size: 50.megabytes, hasher: Glynx::Refile::DateHasher.new)
  Refile.store = Glynx::Refile::FileSystem.new("uploads/cms", hasher: Glynx::Refile::DateHasher.new)
elsif Rails.env.production?
  # do stuff for s3!
end
