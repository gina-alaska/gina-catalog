require 'bundler/capistrano'

set :application, "nssi"
set :repository,  "git@github.com:gina-alaska/nssi-catalog.git"
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
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake sunspot:solr:stop"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake sunspot:solr:start"
  end
  task :reindex, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake sunspot:reindex"
  end

  task :link_configs do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/sunspot.yml #{release_path}/config/sunspot.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/catalog.rb #{release_path}/config/initializers/catalog.rb"
    run "ln -nfs #{deploy_to}/#{shared_dir}/solr/pids #{release_path}/solr/pids"
    run "ln -nfs #{deploy_to}/#{shared_dir}/solr/data #{release_path}/solr/data"
    run "ln -nfs #{release_path}/tools/wkhtmltopdf-amd64 #{release_path}/tools/wkhtmltopdf"
    run "ln -nfs /san/pod/nssi_silo/git #{release_path}/repos"
    run "ln -nfs /san/pod/nssi_silo/archives #{release_path}/archive"
    run "ln -nfs /san/pod/nssi_silo/videos #{release_path}/public/video"
    run "ln -nfs /san/pod/nssi_silo/cms/system #{release_path}/vendor/cms/public/system"
  end
  task :precompile_assets do
    run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
  end
end

after('deploy:update_code', "deploy:link_configs")
after('deploy:update_code', "deploy:precompile_assets")
#after('deploy:update_code', "deploy:reindex")
