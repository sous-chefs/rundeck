#
# Cookbook Name:: wt_streaming_barebones
# Recipe:: undeploy
#
# Copyright 2013, Webtrends
#
# All rights reserved - Do Not Redistribute
#
 
log_dir      = "#{node['wt_common']['log_dir_linux']}/streamingbarebones"
install_dir  = "#{node['wt_common']['install_dir_linux']}/streamingbarebones"
 
runit_service "streamingbarebones" do
 action :disable
end
 
# try to stop the service, but allow a failure without printing the error
service "streamingbarebones" do
 action [:stop, :disable]
 ignore_failure true
end
 
# shell out to force-stop the service if it hasn't stopped cleanly
execute "force-stop" do
 command "sv force-stop streamingbarebones"
 action :run
 returns [0,1]  
end
 
directory log_dir do
 recursive true
 action :delete
end
 
directory install_dir do
 recursive true
 action :delete
end
