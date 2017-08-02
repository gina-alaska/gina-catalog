#
# Cookbook Name:: cookbook
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# ruby_runtime '2.3'
# ruby_gem 'bundler'

include_recipe 'glynx_database::server'
include_recipe 'glynx_elasticsearch::default'
# include_recipe 'glynx_application::default'

# include_recipe 'chef-solo-search::default'
# include_recipe 'glynx-development::fix_yum_mirrors'
#
# include_recipe 'gina-glynx-roles::database_server'
#
# include_recipe 'gina-glynx-roles::elasticsearch_server'
#
# node.override['deploy']['env']['ELASTICSEARCH_HOST'] = '192.168.222.225'
# node.override['db']['host'] = '192.168.222.225'
# node.override['resolver']['nameservers'] = '8.8.8.8'
#
# include_recipe 'gina-glynx-roles::web_server'
#
# env_file = gra_env_file(node['deploy']['environment'])
env_file = node['glynx']['dot_env_path']
dbconfig = chef_vault_item_for_environment('apps', 'glynx')['database']
database_url = "#{dbconfig['adapter']}://#{dbconfig['username']}:#{dbconfig['password']}@#{node['glynx']['database_host']}"

glynx_config env_file do
  owner node['glynx']['user']
  group node['glynx']['group']
  # don't add database_url to the node attributes as it will save the password in plain text
  variables lazy { node['glynx']['env'].to_hash.merge({ DATABASE_URL: database_url }) }
end

execute 'copy_environment' do
  cwd node['glynx']['release_path']
  user node['app']['user']
  group node['app']['group']
  command lazy { "cp #{env_file} .env" }
  # notifies :restart, 'service[puma]', :delayed
  not_if "diff #{env_file} .env"
end

# ENV['BUNDLE_BUILD__PG'] = "--with-pg_config=/usr/pgsql-#{node['postgresql']['version']}/bin/pg_config"
# parent_bundle_resource = bundle_install "#{node['glynx']['release_path']}" do
#   user node['app']['user']
#   deployment false
#   binstubs false
# end
#
# ruby_execute 'setup_development_env' do
#   cwd node['glynx']['release_path']
#   user node['app']['user']
#   command "rake db:migrate"
#   parent_bundle parent_bundle_resource
# end

# execute 'bundle install' do
#   cwd node['glynx']['release_path']
#   user node['app']['user']
#   group node['app']['group']
#   command "bundle install"
#   environment({"BUNDLE_BUILD__PG" => "--with-pg_config=/usr/pgsql-#{node['postgresql']['version']}/bin/pg_config"})
#   notifies :restart, 'service[puma]', :delayed
# end

# execute 'setup_development_env' do
#   cwd node['glynx']['release_path']
#   user node['app']['user']
#   group node['app']['group']
#   command "bundle exec rake db:migrate"
# end

postgresql_connection_info = {
  host: '127.0.0.1',
  port: 5432,
  username: 'postgres'
}

dbconfig = chef_vault_item_for_environment('apps', 'glynx')['database']

# create a postgresql test database
postgresql_database "glynx_test" do
  connection postgresql_connection_info
  action :create
end
#
# execute 'setup_test_env' do
#   cwd node['glynx']['release_path']
#   user node['app']['user']
#   group node['app']['group']
#   command "bundle exec rake db:migrate RAILS_ENV=test"
# end

service 'chef-client' do
  action [:stop, :disable]
end
