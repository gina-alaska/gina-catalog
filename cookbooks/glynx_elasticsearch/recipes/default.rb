#
# Cookbook:: glynx_elasticsearch
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

tag('glynx-elasticsearch')

node.default['java']['install_flavor'] = 'openjdk'
node.default['java']['jdk_version'] = '8'
node.default['elasticsearch']['cluster']['name'] = "elasticsearch_glynx_#{node.chef_environment}"

include_recipe 'java'

elasticsearch_user 'elasticsearch'

elasticsearch_install 'elasticsearch' do
  version '5.2.2'
end

elasticsearch_configure 'elasticsearch' do
  allocated_memory '512m'
  configuration ({
    'cluster.name' => 'glynx_cluster',
    'network.host' => '_site_',
    'node.name' => '${HOSTNAME}',

  })
end

elasticsearch_service 'elasticsearch' do
  action [:enable, :start]
end

include_recipe 'gina_firewall::default'

firewall_rule 'elasticsearch' do
  port 9200
  command :allow
end
