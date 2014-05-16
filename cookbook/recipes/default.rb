#
# Cookbook Name:: glynx
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# include_recipe 'user'
# include_recipe 'user::data_bag'

include_recipe 'glynx::ruby'
include_recipe 'glynx::packages'
include_recipe 'glynx::_database_common'
include_recipe 'postgresql::client'
include_recipe 'glynx::application'
include_recipe 'glynx::unicorn'
include_recipe 'glynx::nginx'