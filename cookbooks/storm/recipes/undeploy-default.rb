#
# Cookbook Name:: storm
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir      = "#{node['storm']['log_dir']}"
install_dir  = "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}"


directory "#{log_dir}" do
  recursive true
  action :delete
end

directory "#{install_dir}" do
  recursive true
  action :delete
end

directory node['storm']['local_dir'] do
  recursive true
  action :delete
end