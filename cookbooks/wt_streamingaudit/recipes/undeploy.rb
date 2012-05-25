#
# Cookbook Name:: wt_streamingaudit
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir      = "#{node['wt_common']['log_dir_linux']}/streamingaudit"
install_dir  = "#{node['wt_common']['install_dir_linux']}/streamingaudit"

runit_service "streamingaudit" do
    action :disable
end

service "streamingaudit" do
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