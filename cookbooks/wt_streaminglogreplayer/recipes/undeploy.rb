#
# Cookbook Name:: wt_streaminglogreplayer
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir      = "#{node['wt_common']['log_dir_linux']}/streaminglogreplayer"
install_dir  = "#{node['wt_common']['install_dir_linux']}/streaminglogreplayer"


runit_service "streaminglogreplayer" do
    action :disable
end 

service "streaminglogreplayer" do
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