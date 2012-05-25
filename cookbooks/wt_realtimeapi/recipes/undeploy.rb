#
# Cookbook Name:: wt_realtimeapi
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir      = "#{node['wt_common']['log_dir_linux']}/realtimeapi"
install_dir  = "#{node['wt_common']['install_dir_linux']}/realtimeapi"


runit_service "realtimeapi" do
    action :disable
end 

service "realtimeapi" do
  action [:stop, :disable]
end

directory "#{log_dir}" do
  recursive true
  action :delete
end

directory "#{install_dir}" do
  recursive true
  action :delete
end