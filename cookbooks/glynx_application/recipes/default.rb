#
# Cookbook:: glynx_application
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

include_recipe 'chef-vault'
include_recipe 'yum-epel'
include_recipe "glynx_database::client"
include_recipe 'glynx_application::_user'

package %w(git nfs-utils bind-utils ImageMagick geos patch libicu-devel curl-devel libxml2-devel libxslt-devel geos-devel proj-devel ImageMagick-devel)

case node['glynx']['deploy_method'].to_sym
when :local
  unless node['glynx']['env']['ELASTICSEARCH_HOST']
    es_results = search(:node, "chef_environment:#{node.chef_environment} AND tags:glynx-elasticsearch", filter_result: {'ip' => ['ipaddress']}).first
    node.default['glynx']['env']['ELASTICSEARCH_HOST'] = es_results.nil? ? 'localhost' : es_results['ip']
  end

  unless node['glynx']['database_host']
    db_results = search(:node, "chef_environment:#{node.chef_environment} AND tags:glynx-database", filter_result: {'ip' => ['ipaddress']}).first
    node.default['glynx']['database_host'] = db_results.nil? ? 'localhost' : db_results['ip']
  end

  directory node['glynx']['install_path'] do
    owner node['glynx']['user']
    group node['glynx']['group']
    recursive true
  end

  glynx_config node['glynx']['dot_env_path'] do
    owner node['glynx']['user']
    group node['glynx']['group']

    dbconfig = chef_vault_item_for_environment('apps', 'glynx')['database']
    database_url = "#{dbconfig['adapter']}://#{dbconfig['username']}:#{dbconfig['password']}@#{node['glynx']['database_host']}"

    # don't add database_url to the node attributes as it will save the password in plain text
    variables lazy { node['glynx']['env'].to_hash.merge({ DATABASE_URL: database_url }) }
  end
  include_recipe 'glynx_application::_puma'
when :habitat
  include_recipe 'glynx_application::_habitat'
end

include_recipe 'gina_firewall::default'
firewall_rule 'puma port' do
  port 9292
  command :allow
end
