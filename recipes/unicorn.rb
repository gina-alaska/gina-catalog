app_name = "glynx"

unicorn_config "/etc/unicorn/#{app_name}.rb" do
  preload_app true
  listen("#{node[app_name]['deploy_path']}/current/tmp/sockets/unicorn.socket" => {backlog: 1024})
  pid("#{node[app_name]['deploy_path']}/current/tmp/pids/unicorn.pid")
  stderr_path("#{node[app_name]['deploy_path']}/shared/log/unicorn.stderr.log")
  stdout_path("#{node[app_name]['deploy_path']}/shared/log/unicorn.stdout.log")
  worker_timeout 30
  worker_processes [node['cpu']['total'].to_i * 4, 8].min
  working_directory "#{node[app_name]['deploy_path']}/current"
  before_fork node[app_name]['before_fork']
  after_fork node[app_name]['after_fork']
end