#
# Cookbook Name:: glynx
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#
app_name = "glynx"

node[app_name]['package_deps'].each do |pkg|
  package pkg do
    action :install
  end
end


include_recipe "gina-webapp::postgresql"
include_recipe "runit"
include_recipe "chruby"

account = node['glynx']['account']

user account

app_name = "glynx"

directory "/home/webdev/.ssh" do
  action :create
  owner account
  group account
  mode 0700
end

node[app_name]['package_deps'].each do |pkg|
  package pkg do
    action :install
  end
end


application app_name do
  path "/www/#{app_name}"
  owner account
  group account
  
  repository "git@github.com:gina-alaska/glynx.git"
  revision "master"
  deploy_key node['glynx']['deploy_key']
  rails do
    #database_master_role "#{app_name}_database_master"
    gems ["bundler"]
    precompile_assets true
    environment({"BUNDLE_BUILD__PG" => "--with-pg_config=#{node["postgresql"]["bindir"]}/pg_config"})
    database do
      database "nssi_dev" #node[app_name]['database']['name']
      username "nssi_dev" #node[app_name]['database']['username']
      password "g0d0fn551"#node[app_name]['database']['password']
      adapter "postgis"
      schema_search_path "nssi_dev,public"
      host "yang.gina.alaska.edu"
      client_encoding "UTF8"
    end
  end
  unicorn do
    #only_if {node['roles'].include?("#{app_name}_web_server")}
    preload_app true
    port "8000"
    worker_timeout 30
    worker_processes 2
    bundle_command "/www/#{app_name}/bundle_wrapper.sh"
  end

  # nginx_load_balancer do
  #   #only_if {node['roles'].include?("#{app_name}_load_balancer")}
  #   static_files "/assets" => "assets"
  # end
end


cookbook_file "/www/#{app_name}/bundle_wrapper.sh" do
  source "bundle_wrapper.sh"
  owner account
  group account
  mode 0755
end

service "#{app_name}" do 
  action [:enable, :start]
end