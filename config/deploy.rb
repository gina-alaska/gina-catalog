require 'bundler/capistrano'

set :application, "nssi"
set :repository,  "git@gitorious.gina.alaska.edu:nssi/catalog_v2.git"
set :deploy_to, "/www/nssi-prod"

ssh_options[:forward_agent] = true

set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :use_sudo, false
set :user, "webdev"
server "nssi-vm", :app, :web, :db, :primary => true

#role :web, "webdev@nssi-vm"                          # Your HTTP server, Apache/etc
#role :app, "webdev@nssi-vm"                          # This may be the same as your `Web` server
#role :db,  "webdev@nssi-vm", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :link_configs do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
  end
  task :precompile_assets do
    run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
  end
end

after('deploy:update_code', "deploy:link_configs")
after('deploy:update_code', "deploy:precompile_assets")
