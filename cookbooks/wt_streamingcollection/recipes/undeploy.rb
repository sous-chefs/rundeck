#
# Cookbook Name:: wt_streamingcollection
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir      = "#{node['wt_common']['log_dir_linux']}/streamingcollection"
install_dir  = "#{node['wt_common']['install_dir_linux']}/streamingcollection"

runit_service "streamingcollection" do
    action :disable
    run_restart false
end

# try to stop the service, but allow a failure without printing the error
service "streamingcollection" do
  action [:stop, :disable]
  ignore_failure true
end

# shell out to force-stop the service if it hasn't stopped cleanly
execute "force-stop" do
  command "sv force-stop streamingcollection"
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