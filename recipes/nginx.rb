app_name = "glynx"
node.default!['nginx']['default_site_enabled'] = false
include_recipe "gina-webapp::nginx"

gina_webapp app_name do
  install_path node[app_name]['deploy_path']
  user node[app_name]['account']
end

nginx_site "#{app_name}_site"