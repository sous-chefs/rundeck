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

# try to stop the service, but allow a failure without printing the error
service "streaminglogreplayer" do
  action [:stop, :disable]
  returns [0,1]
end

# force stop the service incase the stop failed
service "streaminglogreplayer" do
  action [:force-stop, :disable]
end

directory "#{log_dir}" do
  recursive true
  action :delete
end

directory "#{install_dir}" do
  recursive true
  action :delete
end