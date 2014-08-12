user node['glynx']['account']

directory node['unicorn']['listen'] do
 user node['glynx']['account']
 group node['glynx']['account']
 recursive true
 action :create
end

unicorn_config node['unicorn']['config_path'] do
  # preload_app node['unicorn']['preload_app']
  preload false
  listen "#{node['unicorn']['listen']}/glynx.socket" => {backlog: 1024}
  pid node['unicorn']['pid']
  stderr_path node['unicorn']['stderr']
  stdout_path node['unicorn']['stdout']
  worker_timeout node['unicorn']['worker_timeout']
  worker_processes [node['cpu']['total'].to_i * 4, 8].min
  working_directory node['unicorn']['deploy_path']
  before_fork node['unicorn']['before_fork']
  after_fork node['unicorn']['after_fork']
end

template "/etc/init.d/unicorn_glynx" do
  source "unicorn_init.erb"
  action :create
  mode 00755
  variables({
    install_path: node['glynx']['paths']['deploy'],
    user: node['glynx']['account'],
    pidfile: node['unicorn']['pid'],
    unicorn_config_file: node['unicorn']['config_path'],
    environment: node['glynx']['environment']
  })
end

service "unicorn_glynx" do 
  action [:enable]
end