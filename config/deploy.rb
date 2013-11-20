set :application, 'glynx'
set :repo_url, 'git@github.com:gina-alaska/gina-catalog.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/www/glynx'
set :scm, :git

set :format, :pretty
set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/database.yml config/initializers/catalog.rb config/resque.yml config/git_hooks_env config/sunspot.yml}
set :linked_dirs, %w{bin log tmp vendor/bundle public/assets public/system archive repos uploads git}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

set :rails_env, :production
# set :unicorn_binary, "/usr/bin/unicorn"
set :unicorn_config, "/etc/unicorn/glynx.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
 


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      execute :kill, '-USR2', "`cat #{release_path.join('tmp/pids/unicorn.pid')}`"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
