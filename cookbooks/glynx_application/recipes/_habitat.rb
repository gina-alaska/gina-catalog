#
# Cookbook:: glynx_application
# Recipe:: habitat
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

node.default['glynx']['package'] = 'uafgina-glynx-3.9.12-20170502235516-x86_64-linux.hart'
node.default['glynx']['package_checksum'] = '55e2bf8ac065857ecd52fdd1e837e2defcca202ce4cc5107c9e08171ca030a22'

unless node['glynx']['elasticsearch_host']
  es_results = search(:node, "chef_environment:#{node.chef_environment} AND tags:glynx-elasticsearch", filter_result: {'ip' => ['ipaddress']}).first
   node.default['glynx']['elasticsearch_host'] = es_results.nil? ? 'localhost' : es_results['ip']
end

unless node['glynx']['database_host']
  db_results = search(:node, "chef_environment:#{node.chef_environment} AND tags:glynx-database", filter_result: {'ip' => ['ipaddress']}).first
  node.default['glynx']['database_host'] = db_results.nil? ? 'localhost' : db_results['ip']
end

config = chef_vault_item_for_environment('apps', 'glynx')
dbconfig = config['database']

user_toml = {
  'database_adapter' => dbconfig['adapter'],
  'database_host' => node['glynx']['database_host'],
  'database_username' => dbconfig['username'],
  'database_password' => dbconfig['password'],
  'secret_key_base' => config['secret_key_base'],
  'glynx_storage_path' => ::File.join(node['glynx']['storage_mount'], 'glynx_uploads'),
  'gina_analytics' => 'UA-6824535-22',
  'elasticsearch_host' =>  node['glynx']['elasticsearch_host']
}

glynx_package 'uafgina/glynx' do
  source_url "https://s3-us-west-2.amazonaws.com/gina-packages/#{node['glynx']['package']}"
  source_checksum node['glynx']['package_checksum']
  config user_toml
end
