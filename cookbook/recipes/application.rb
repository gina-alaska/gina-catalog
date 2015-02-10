include_recipe 'glynx::packages'
include_recipe 'glynx::ruby'
include_recipe 'glynx::_database_common'
include_recipe 'postgresql::client'

app_name = 'glynx'
account = node[app_name]['account']

# %w{ application_path shared_path config_path initializers_path  }.each do |dir|
#   directory node[app_name][dir] do
#     owner account
#     group account
#     mode 00755
#     action :create
#   end
# end

# %w{public solr}.each do |shared_dir|
#   directory File.join(node[app_name]['shared_path'], shared_dir) do
#     owner account
#     group account
#     mode 00755
#   end
# end

# directory node[app_name]['catalog_silo_path'] do
#   action :create
#   recursive true
# end

# mount node[app_name]['catalog_silo_path'] do
#   device 'pod.gina.alaska.edu:/pod/nssi_silo'
#   fstype 'nfs'
#   options 'rw'
#   action [:mount, :enable]
# end

# link File.join(node[app_name]['shared_path'], 'archive') do
#   to File.join(node[app_name]['catalog_silo_path'], 'archives')
#   owner account
#   group account
# end

# link File.join(node[app_name]['shared_path'], 'repos') do
#   to File.join(node[app_name]['catalog_silo_path'], 'git')
#   owner account
#   group account
# end

# link File.join(node[app_name]['shared_path'], 'uploads') do
#   to File.join(node[app_name]['catalog_silo_path'], 'uploads')
#   owner account
#   group account
# end

# link File.join(node[app_name]['shared_path'], 'public/cms') do
#   to File.join(node[app_name]['catalog_silo_path'], 'cms')
#   owner account
#   group account
# end

node[app_name]['paths'].each do |_name, path|
  directory path do
    owner account
    group account
    mode 00755
    action :create
    recursive true
  end
end

package 'nfs-utils'
service 'rpcbind' do
  action [:enable, :start]
end

node[app_name]['mounts'].each do |_name, mnt|
  directory mnt['mount_point'] do
    recursive true
  end
  mount mnt['mount_point'] do
    device mnt['device']
    fstype mnt['fstype'] if mnt['fstype']
    options mnt['options'] if mnt['options']
    action mnt['action']
  end
end

node[app_name]['links'].each do |_name, lnk|
  link lnk['name'] do
    to lnk['to']
    owner account
    group account
    action lnk['action']
  end
end

template "#{node[app_name]['paths']['shared']}/config/sunspot.yml" do
  owner account
  group account
  mode 00644
  variables(
    environment: node[app_name]['environment'],
    solr: node[app_name]['sunspot']['solr']
  )
end

template "#{node[app_name]['paths']['shared']}/config/database.yml" do
  owner account
  group account
  mode 00644
  variables(
    databases: node[app_name]['database']
  )
end

template "#{node[app_name]['paths']['shared']}/config/secrets.yml" do
  owner account
  group account
  mode 00644
  variables(
    secrets: node[app_name]['rails']['secrets']
  )
end

# template "#{node[app_name]['shared_path']}/config/git_hooks_env" do
#   owner account
#   group account
#   mode 00644
# end

# template "#{node[app_name]['paths']['shared']}/config/initializers/catalog.rb" do
#   owner account
#   group account
#   mode 00644
#   variables(deploy_path: node[app_name]['paths']['deploy'])
# end

# template "#{node[app_name]['shared_path']}/config/resque.yml" do
#   owner account
#   group account
#   mode 00644
#
#   variables(node[app_name]['redis'])
# end

directory "/home/#{account}/.bundle" do
  owner account
  group account
  mode 00755
  action :create
end

template "/home/#{account}/.bundle/config" do
  source 'bundle/config.erb'
  owner account
  group account
  mode 00644
end

%w(log tmp system tmp/pids tmp/sockets).each do |dir|
  directory "#{node[app_name]['paths']['shared']}/#{dir}" do
    owner node[app_name]['account']
    group node[app_name]['account']
    mode 0755
  end
end

link "/home/#{account}/#{app_name}" do
  to node[app_name]['paths']['deploy']
  owner node[app_name]['account']
  group node[app_name]['account']
end
