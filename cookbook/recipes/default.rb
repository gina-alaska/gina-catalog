#
# Cookbook Name:: glynx
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# Default recipe should only be used for all-in-one deployments of glynx
include_recipe 'glynx::database'
include_recipe 'glynx::redis'
include_recipe 'glynx::solr'
include_recipe 'glynx::web'
# include_recipe 'glynx::worker'
