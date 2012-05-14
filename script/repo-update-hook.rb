raise "Unable to find REPO_PATH environment variable" unless ENV['REPO_PATH']

RAILS_ROOT = File.expand_path('..', File.dirname(__FILE__))
repository = /([^\/]*?)\.git$/.match(ENV['REPO_PATH'])[1]

repo = Repo.where('repohex = ?', repository).first
raise "Unable to find repo #{repository}" if repo.nil?

puts "Scheduling update for repo archive"
repo.try(:async_create_archive)
repo.try(:async_update_cdn_clone)
