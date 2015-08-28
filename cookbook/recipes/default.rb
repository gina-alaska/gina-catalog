#
# Cookbook Name:: cookbook
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# include_recipe 'chef-solo-search::default'
include_recipe 'glynx-development::fix_yum_mirrors'

include_recipe 'gina-glynx-roles::database_server'

include_recipe 'gina-glynx-roles::elasticsearch_server'

node.override['deploy']['env']['ELASTICSEARCH_HOST'] = '192.168.222.225'
node.override['db']['host'] = '192.168.222.225'
node.override['resolver']['nameservers'] = '8.8.8.8'

include_recipe 'gina-glynx-roles::web_server'

execute 'bundle install' do
  cwd ::File.join(node['app']['install_path'], 'current')
  user node['app']['user']
  group node['app']['group']
  command "bundle install --path=vendor/bundle"
  environment({"BUNDLE_BUILD__PG" => "--with-pg_config=/usr/pgsql-#{node['postgresql']['version']}/bin/pg_config"})
  notifies :restart, 'service[puma]', :delayed
end

execute 'copy_environment' do
  cwd node['app']['install_path']
  user node['app']['user']
  group node['app']['group']
  command "cp shared/.env.production current/.env"
  notifies :restart, 'service[puma]', :delayed
  not_if 'diff shared/.env.production current/.env'
end


ruby_block 'set_development_deployed' do
  action :nothing
  block do
    node.default['app']['development_deployed'] = true
  end
end

execute 'setup_test_env' do
  action :nothing
  cwd ::File.join(node['app']['install_path'], 'current')
  user node['app']['user']
  group node['app']['group']
  command "bundle exec rake db:migrate db:seed RAILS_ENV=test"
end

execute 'setup_development_env' do
  cwd ::File.join(node['app']['install_path'], 'current')
  user node['app']['user']
  group node['app']['group']
  command "bundle exec rake db:migrate db:seed"
  not_if { node['app']['development_deployed'] }
  notifies :run, "ruby_block[set_development_deployed]", :immediately
  notifies :run, "execute[setup_test_env]", :immediately
end


service 'chef-client' do
  action [:stop, :disable]
end
