if Rails.env.development?
  Refile.cache = Refile::Backend::FileSystem.new("tmp")
  Refile.store = Refile::Backend::FileSystem.new("uploads/cms")
elsif Rails.env.production?
  # do stuff for s3!
end
