#
# Cookbook:: glynx_database
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright:: 2017, UAF GINA
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

tag('glynx-database')

include_recipe 'yum-epel'
include_recipe 'chef-vault::default'

dbconfig = chef_vault_item_for_environment('apps', 'glynx')['database']

node.default['postgresql']['pg_hba'] << {
  type: 'host',
  db: dbconfig['name'],
  user: dbconfig['username'],
  addr: 'all',
  method: 'md5'
}

include_recipe 'postgresql::config_initdb'
include_recipe 'postgresql::config_pgtune'
include_recipe 'postgresql::server'
include_recipe 'postgresql::contrib'

include_recipe 'database::postgresql'

postgresql_connection_info = {
  host: '127.0.0.1',
  port: 5432,
  username: 'postgres'
}

# create a postgresql database
postgresql_database dbconfig['name'] do
  connection postgresql_connection_info
  action :create
end

# Create a postgresql user but grant no privileges
postgresql_database_user dbconfig['username'] do
  connection postgresql_connection_info
  password dbconfig['password']
  superuser true
  createdb true
  action :create
end

# Grant all privileges on all tables in foo db
postgresql_database_user dbconfig['username'] do
  connection postgresql_connection_info
  database_name dbconfig['name']
  privileges [:all]
  action :grant
end
