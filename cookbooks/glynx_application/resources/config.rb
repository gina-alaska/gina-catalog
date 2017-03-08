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

resource_name 'glynx_config'

property :filename, String, name_property: true
property :source, String, default: 'env.erb'
property :cookbook, String, default: 'glynx_application'
property :owner, String
property :group, String
property :variables, Hash, default: {}

action :create do
  directory ::File.dirname(new_resource.filename) do
    owner new_resource.owner if new_resource.owner
    group new_resource.group if new_resource.group
    recursive true
  end

  template new_resource.filename do
    source new_resource.source
    cookbook new_resource.cookbook
    owner new_resource.owner if new_resource.owner
    group new_resource.group if new_resource.group
    variables(config: new_resource.variables)
  end
end
