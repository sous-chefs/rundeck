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
    run_restart false
end 

# try to stop the service, but allow a failure without printing the error
service "streamingaudit" do
  action [:stop, :disable]
  ignore_failure true
end

# force stop the service in case the stop failed
service "streamingaudit" do
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