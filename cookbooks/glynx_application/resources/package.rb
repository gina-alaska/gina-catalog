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
# require 'toml'

resource_name 'glynx_package'

property :source_url, String
property :source_checksum, String
property :config, Hash, required: true
property :service_path, String, default: '/hab/svc/glynx'

action :install do
  gina_hab_install 'default' do
    version '0.26.1'
  end

  if new_resource.source_url
    gina_hab_package new_resource.name do
      source new_resource.source_url
      checksum new_resource.source_checksum
    end
  else
    hab_package new_resource.name do
      channel 'unstable'
    end
  end

  directory new_resource.service_path do
    owner 'hab'
    group 'hab'
    action :create
    recursive true
  end

  template ::File.join(new_resource.service_path, 'user.toml') do
    owner 'hab'
    group 'hab'
    mode '0600'
    source 'habitat_user.toml.erb'
    cookbook 'glynx_application'
    variables new_resource.config
    notifies :restart, "hab_service[#{new_resource.name}]", :delayed
  end

  hab_service new_resource.name do
    strategy 'at-once'
    action [:load, :start]
  end
end
