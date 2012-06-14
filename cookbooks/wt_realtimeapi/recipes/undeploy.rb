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
    run_restart false
end 

# try to stop the service, but allow a failure without printing the error
service "realtimeapi" do
  action [:stop, :disable]
  ignore_failure true
end

# force stop the service in case the stop failed
service "realtimeapi" do
  action [:stop]
  stop_command "force-stop"
end

directory "#{log_dir}" do
  recursive true
  action :delete
end

directory "#{install_dir}" do
  recursive true
  action :delete
end