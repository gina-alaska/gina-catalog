#
# Cookbook:: glynx_application
# Recipe:: puma
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

# include_recipe 'runit::default'

# directory '/var/run/puma' do
#   owner node['glynx']['user']
#   group node['glynx']['group']
# end

# runit_service 'puma' do
#   action [:enable, :start]
#   log true
#   default_logger true
#   options(
#     release_path: node['glynx']['release_path'],
#     ruby_version: node['glynx']['ruby_version']
#   )
#   env(node['glynx']['env'])
#
#   # adding this in cause on initial deploy this may fail if the code isn't deployed yet
#   ignore_failure true
#
#   subscribes :usr1, "template[#{node['glynx']['install_path']}/shared/.env]", :delayed
# end

systemd_service 'puma' do
  description 'gLynx Puma Application Server'
  after %w( network.target )
  service do
    # environment({ "ICEWATCH_APP" => "web" })
    exec_start "#{node['glynx']['release_path']}/bin/puma -c #{node['glynx']['release_path']}/config/puma.rb"
    kill_signal 'SIGINT'
    kill_mode 'process'
    private_tmp true
  end
  only_if { ::File.open('/proc/1/comm').gets.chomp == 'systemd' } # systemd
end

service 'puma' do
  action [:enable, :start]
end
