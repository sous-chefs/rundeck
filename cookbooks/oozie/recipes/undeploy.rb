#
# Cookbook Name:: oozie
# Recipe:: default
# Author:: Robert Towne(<robert.towne@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# this recipe UN-installs oozie



install_dir  = node['oozie']['install_path']
log_dir      = node['oozie']['log_dir']
version      = node['oozie']['version']

primary_dir  = "#{install_dir}/oozie-#{version}"
linked_dir   = "#{install_dir}/oozie"


directory log_dir do
  recursive true
  action :delete
end

directory primary_dir do
  recursive true
  action :delete
end


directory linked_dir do
  recursive true
  action :delete
end
