app_name = "glynx"
node.default!['nginx']['default_site_enabled'] = false

include_recipe 'nginx'

ruby_block 'move_nginx_confs' do
  block do
    if File.exists? '/etc/nginx/conf.d'
      FileUtils::rm_rf '/etc/nginx/conf.d'
    end
  end
end

template "/etc/nginx/sites-available/#{app_name}_site" do
  source 'nginx_site.erb'
  variables({
    install_path: node[app_name]['deploy_path'],
    name: app_name,
    user: node[app_name]['account']
  })
end

nginx_site "#{app_name}_site"