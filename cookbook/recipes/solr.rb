app_name = "glynx"

include_recipe "glynx::application"
include_recipe "java"

template "/etc/init.d/solr_#{app_name}" do
  source "solr_init.erb"
  action :create
  mode 00755
  variables({
    install_path: node[app_name]['deploy_path'],
    user: node[app_name]['account'],
    ruby_path: "/opt/rubies/ruby-1.9.3-p448",
    environment: node[app_name]['environment']
  })
end

service "solr_#{app_name}" do 
 action [:enable]
end
