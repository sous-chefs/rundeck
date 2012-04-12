#
# Cookbook Name:: wt_streamingapi
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir      = "#{node['wt_common']['log_dir_linux']}/streamingapi"
install_dir  = "#{node['wt_common']['install_dir_linux']}/streamingapi"

service "streamingapi" do
  action [:stop, :disable]
end

directory "#{log_dir}" do
  action :delete
end

directory "#{install_dir}" do
  action :delete
end