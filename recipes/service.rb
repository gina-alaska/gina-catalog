app_name = "glynx"

cookbook_file "/home/webdev/bundle_wrapper.sh" do
  owner 'webdev'
  group 'webdev'
  mode 0755
end

runit_service app_name do
  run_template_name 'unicorn'
  log_template_name 'unicorn'
  
  owner 'webdev'
  group 'webdev'

  options(
    app: app_name,
    path: node[app_name]['deploy_path'],
    user: 'webdev',
    group: 'webdev',
    bundler: true,
    bundle_command: "/home/webdev/bundle_wrapper.sh",
    rails_env: "production",
    smells_like_rack: true
  )
end

service app_name do 
  action [:start]
end
