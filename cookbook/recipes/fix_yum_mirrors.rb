#
# Cookbook Name:: cookbook
# Recipe:: fix_yum_mirrors
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'yum'

template "/etc/yum/pluginconf.d/fastestmirror.conf" do
  mode 0544
  owner 'root'
  group 'root'
  variables({ excluded_mirrors: 'mirrors.tummy.com' })
end
