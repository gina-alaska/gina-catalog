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
require 'toml'

resource_name 'glynx_package'

property :source_url, String
property :source_checksum, String
property :config, Hash, required: true
property :service_path, String, default: '/hab/svc/glynx'

action :install do
  hab_install 'install habitat'

  user 'hab' do
    comment 'habitat account'
    home '/hab'
    manage_home true
  end

  if new_resource.source_url
    local_package = "#{Chef::Config[:file_cache_path]}/#{::File.basename(new_resource.source_url)}"

    remote_file local_package do
      source new_resource.source_url
      checksum new_resource.source_checksum
      notifies :run, 'execute[hab-install-local]', :immediately
    end

    execute 'hab-install-local' do
      command "hab pkg install #{local_package}"
      action :nothing
      notifies :restart, "hab_service[#{new_resource.name}]"
    end
  else
    hab_package new_resource.name
  end

  directory new_resource.service_path do
    owner 'hab'
    group 'hab'
    action :create
    recursive true
  end

  file ::File.join(new_resource.service_path, 'user.toml') do
    owner 'hab'
    group 'hab'
    mode '0600'
    content TOML.dump(new_resource.config)
    notifies :restart, "hab_service[#{new_resource.name}]"
  end

  hab_sup 'default'

  hab_service new_resource.name do
    action [:load]
  end
end
