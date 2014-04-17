#
# Cookbook Name:: glynx
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
app_name = "glynx"

account = node[app_name]['account']

include_recipe 'gina'
include_recipe 'user'
include_recipe 'user::data_bag'

include_recipe "glynx::packages"
include_recipe "glynx::ruby"
include_recipe 'glynx::nginx'
include_recipe 'glynx::unicorn'
include_recipe 'gina-postgresql::client'
include_recipe 'glynx::application'
