#
# Cookbook Name:: wt_streaminglogreplayer
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir = File.join(node['wt_common']['log_dir_linux'], "streaminglogreplayer")
install_dir = File.join(node['wt_common']['install_dir_linux'], "streaminglogreplayer")

# try to stop the service, but allow a failure without printing the error
service "streaminglogreplayer" do
  action [:stop, :disable]
  ignore_failure true
end

directory log_dir do
  recursive true
  action :delete
end

directory install_dir do
  recursive true
  action :delete
end