app_name = "glynx"
db_conf = node[app_name]['database']

application app_name do
  
  path node[app_name]['deploy_path']
  owner node[app_name]['account']
  group node[app_name]['account']
  
  repository node[app_name]['repository']
  revision node[app_name]['revision']
  deploy_key node[app_name]['deploy_key'] #app_deploy_key[:key]
  
  purge_before_symlink(['log','tmp','public/system'])
  symlinks({
    "log" => "log", 
    "tmp" => "tmp", 
    "system" => "public/system", 
    "bundle" => "vendor/bundle"
  })
  
  rails do
    use_omnibus_ruby false
  
    gems ["bundler"]
    precompile_assets true
    environment({"BUNDLE_BUILD__PG" => "--with-pg_config=#{node["postgresql"]["bindir"]}/pg_config"})

    database do
      database db_conf['name']
      username db_conf['username']
      password db_conf['password']
      adapter "postgresql"
      schema_search_path "public"
      host db_conf['host']
      client_encoding "UTF8"
    end
  end
end

%w{log tmp system tmp/pids tmp/sockets}.each do |dir|
  directory "#{node[app_name]['deploy_path']}/shared/#{dir}" do
    owner node[app_name]['account']
    group node[app_name]['account']
    mode 0755
  end
end

link "/home/webdev/#{app_name}" do
  to node[app_name]['deploy_path']
  owner node[app_name]['account']
  group node[app_name]['account']
end
# 
# mount "#{node[app_name]['deploy_path']}/shared/system" do
#   fstype "nfs"
#   device "pod2.gina.alaska.edu:/gvolglynx"
#   action [:mount, :enable]
# end
