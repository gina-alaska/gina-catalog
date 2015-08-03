node['glynx']['database']['environments'].each do |dbenv|
  dbinfo = node['glynx']['database'][dbenv]

  node.default['postgresql']['pg_hba'] += [{
    type: 'host',
    db: dbinfo['database'],
    user: dbinfo['username'],
    addr: 'all',
    method: 'trust'
  }, {
    type: 'host',
    db: 'postgres',
    user: dbinfo['username'],
    addr: 'all',
    method: 'trust'
  }]
end


include_recipe 'postgresql::config_initdb'
include_recipe 'postgresql::config_pgtune'
include_recipe 'postgresql::server'
include_recipe 'postgresql::contrib'
include_recipe 'database::postgresql'

postgresql_connection_info = {
  host: '127.0.0.1',
  port: 5432,
  username: 'postgres',
  password: node['postgresql']['password']['postgres']
}

node['glynx']['database']['environments'].each do |dbenv|
  dbinfo = node['glynx']['database'][dbenv]

  postgresql_database_user dbinfo['username'] do
    connection postgresql_connection_info
    password dbinfo['password']
    superuser true
    createdb true
    action [:create]
  end

  # create a postgresql database
  postgresql_database dbinfo['database'] do
    connection postgresql_connection_info
    owner dbinfo['username']
    action :create
  end

  # Grant all privileges on all tables in foo db
  postgresql_database_user dbinfo['username'] do
    connection postgresql_connection_info
    database_name dbinfo['database']
    privileges [:all]
    action :grant
  end
end
