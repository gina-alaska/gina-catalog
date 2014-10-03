#Install gems

directory "#{node['glynx']['deploy_path']}/.bundle" do
	owner node['glynx']['account']
	group node['glynx']['account']
end

template "#{node['glynx']['deploy_path']}/.bundle/config" do
  source "bundle/config.erb"
  owner node['glynx']['account']
  group node['glynx']['account']
  mode 00644
end

execute "bundle_install" do
	command "chruby-exec 1.9.3 -- bundle install --path=./.gems --verbose > /tmp/gemlog"
	cwd node['glynx']['deploy_path']
	user node['glynx']['account']
	group node['glynx']['account']	
end

execute "glynx_rake_db_setup" do 
  command "chruby-exec 1.9.3 -- bundle exec rake db:setup" 
  cwd node['glynx']['deploy_path']
  user node['glynx']['account']
  group node['glynx']['account']  
  only_if { node['glynx']['database_setup'] }
end

service 'unicorn_glynx' do
  action :start
end

service 'solr_glynx' do 
  action :start
  #notifies :run, 'execute[solr_reindex]', :delayed
end

execute "solr_reindex" do 
  # environment({"PATH" => "/opt/rubies/ruby-1.9.3-p448/bin:/usr/local/bin:/usr/bin:/bin"})
  command "chruby-exec 1.9.3 -- bundle exec rake sunspot:solr:reindex"
  cwd node['glynx']['deploy_path']
  user node['glynx']['account']
  group node['glynx']['account']
  notifies :touch, "file[solr_noreindex]", :delayed
  action :nothing
  not_if {::File.exists?("/home/#{node['glynx']['account']}/solr_noreindex")}
end

file "solr_noreindex" do
  path "/home/#{node['glynx']['account']}/solr_noreindex"
  action :nothing
end
