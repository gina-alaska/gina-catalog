include_recipe 'glynx::default'
include_recipe 'gina-postgresql::client'

directory "/www"

app_name = "glynx"
account = node[app_name]['account']

%w{ application_path shared_path config_path initializers_path  }.each do |dir|
  directory node[app_name][dir] do
    owner account
    group account
    mode 00755
    action :create
  end
end

directory File.join(node[app_name]['shared_path'], 'public') do
  owner account
  group account
  mode 00755
end

directory node[app_name]['catalog_silo_path'] do
  action :create
  recursive true
end

service 'rpcbind' do
  action [:enable, :start]
end

mount node[app_name]['catalog_silo_path'] do
  device 'pod.gina.alaska.edu:/pod/nssi_silo'
  fstype 'nfs'
  options 'rw'
  action [:mount, :enable]
end

link File.join(node[app_name]['shared_path'], 'archive') do
  to File.join(node[app_name]['catalog_silo_path'], 'archives') 
  owner account
  group account
end

link File.join(node[app_name]['shared_path'], 'repos') do
  to File.join(node[app_name]['catalog_silo_path'], 'git') 
  owner account
  group account
end

link File.join(node[app_name]['shared_path'], 'uploads') do
  to File.join(node[app_name]['catalog_silo_path'], 'uploads') 
  owner account
  group account
end

link File.join(node[app_name]['shared_path'], 'public/cms') do
  to File.join(node[app_name]['catalog_silo_path'], 'cms') 
  owner account
  group account
end

template "#{node[app_name]['shared_path']}/config/sunspot.yml" do
  owner account
  group account
  mode 00644  
  variables(
    :production_host => node[app_name]["sunspot"]["hostname"],
    :production_port => node[app_name]["sunspot"]["port"]
  )
end

template "#{node[app_name]['shared_path']}/config/database.yml" do
  owner account
  group account
  mode 00644
    
  variables(node[app_name]["database"])
end

template "#{node[app_name]['shared_path']}/config/git_hooks_env" do
  owner account
  group account
  mode 00644
end

template "#{node[app_name]['shared_path']}/config/initializers/catalog.rb" do
  owner account
  group account
  mode 00644  
  
  variables({ deploy_path: node[app_name]['deploy_path'] })
end

template "#{node[app_name]['shared_path']}/config/resque.yml" do
  owner account
  group account
  mode 00644  
  
  variables(node[app_name]['redis'])
end

directory "/home/#{account}/.bundle" do
  owner account
  group account
  mode 00755
  action :create
end

template "/home/#{account}/.bundle/config" do
  source "bundle/config.erb"
  owner account
  group account
  mode 00644
end

# db_conf = node[app_name]['database']
# 
# application app_name do
#   
#   path node[app_name]['deploy_path']
#   owner node[app_name]['account']
#   group node[app_name]['account']
#   
#   repository node[app_name]['repository']
#   revision node[app_name]['revision']
#   deploy_key node[app_name]['deploy_key'] #app_deploy_key[:key]
#   
#   purge_before_symlink(['log','tmp','public/system'])
#   symlinks({
#     "log" => "log", 
#     "tmp" => "tmp", 
#     "system" => "public/system", 
#     "bundle" => "vendor/bundle"
#   })
#   
#   rails do
#     use_omnibus_ruby false
#   
#     gems ["bundler"]
#     precompile_assets true
#     environment({"BUNDLE_BUILD__PG" => "--with-pg_config=#{node["postgresql"]["bindir"]}/pg_config"})
# 
#     database do
#       database db_conf['name']
#       username db_conf['username']
#       password db_conf['password']
#       adapter "postgresql"
#       schema_search_path "public"
#       host db_conf['host']
#       client_encoding "UTF8"
#     end
#   end
# end
# 
%w{log tmp system tmp/pids tmp/sockets}.each do |dir|
  directory "#{node[app_name]['shared_path']}/#{dir}" do
    owner node[app_name]['account']
    group node[app_name]['account']
    mode 0755
  end
end

link "/home/webdev/#{app_name}" do
  to node[app_name]['deploy_path']
  owner node[app_name]['account']
  group node[app_name]['account']
end
# # 
# # mount "#{node[app_name]['deploy_path']}/shared/system" do
# #   fstype "nfs"
# #   device "pod2.gina.alaska.edu:/gvolglynx"
# #   action [:mount, :enable]
# # end

#last thing to do is enable the unicorn service
include_recipe 'glynx::service'