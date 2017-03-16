source 'https://supermarket.chef.io'
source :chef_server

def local_cookbook(name)
  cookbook name, path: "cookbooks/#{name}"
end

cookbook 'gina-server'
local_cookbook 'glynx_database'
local_cookbook 'glynx_application'
local_cookbook 'glynx_elasticsearch'
