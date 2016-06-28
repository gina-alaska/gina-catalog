# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'glynx'
set :repo_url, 'git@github.com:gina-alaska/gina-catalog.git'

# Default branch is :master
ask :branch, `cat VERSION`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/www/glynx'

set :migration_role, 'migrator'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('.env.production')
# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'uploads')

# Default value for default_env is {}
# set :default_env, {  }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc "First time setup"
  task :first_time do
    on roles(:app, primary: true), limit: 1 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:seed'
          execute :rake, 'searchkick:reindex:all'
        end
      end
    end
  end

  desc "Reindex elastic search"
  task :reindex do
    on roles(:app, primary: true), limit: 1 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'searchkick:reindex:all'
        end
      end
    end
  end

  task :fix_entry_owners do
    on roles(:app, primary: true), limit: 1 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'admin:fix_entry_owners'
        end
      end
    end
  end
end
