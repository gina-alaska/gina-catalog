include_recipe 'glynx::_database_common'
include_recipe 'yum-epel'

node.default['postgresql']['pg_hba'] += [{
	:type => 'host', 
	:db => node['glynx']['database']['database'], 
	:user => node['glynx']['database']['username'], 
	:addr => 'all', 
	:method => 'trust'
},{
  :type => 'host', 
  :db => 'postgres', 
  :user => node['glynx']['database']['username'], 
  :addr => 'all', 
  :method => 'trust'
}]

include_recipe 'postgresql::server'
include_recipe 'database::default'
include_recipe 'postgresql::ruby'

postgresql_connection_info = {
	host: '127.0.0.1',
	port: 5432,
	username: 'postgres',
	password: node['postgresql']['password']['postgres']
}

# create a postgresql database
postgresql_database node['glynx']['database']['database'] do
  connection postgresql_connection_info
  action :create
end

# Create a postgresql user but grant no privileges
postgresql_database_user node['glynx']['database']['username'] do
  connection postgresql_connection_info
  password   node['glynx']['database']['password']
  action     :create
end

# Grant all privileges on all tables in foo db
postgresql_database_user node['glynx']['database']['username'] do
  connection    postgresql_connection_info
  database_name  node['glynx']['database']['database']
  privileges    [:all]
  action        :grant
end


#Ghetto way of doing it.
#  Lets work on a postgis cookbook at soem point
package 'postgis2_92'
package 'postgis2_92-devel'

#  Example what the dsl might look like
# postgis_database node['glynx']['database'] do
#   action :create
# end

bash 'enable_postgis' do 
  user 'postgres'
  code <<-EOS
    psql -d #{node['glynx']['database']['database']} -c "CREATE EXTENSION IF NOT EXISTS postgis;"
    psql -d #{node['glynx']['database']['database']} -c "CREATE EXTENSION IF NOT EXISTS postgis_topology;"
  EOS
end