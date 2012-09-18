#
# Cookbook Name:: storm
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

install_dir  = "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}"


# clean out the install directory from the previous version
directory "#{install_dir}" do
  recursive true
  action :delete
end

# clean out the local state from the previous version
directory node['storm']['local_dir'] do
  recursive true
  action :delete
end