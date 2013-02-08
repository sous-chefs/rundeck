#
# Cookbook Name:: wt_kafka_topagg
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

log_dir      = "#{node['wt_common']['log_dir_linux']}/topagg"
install_dir  = "#{node['wt_common']['install_dir_linux']}/topagg"

runit_service "topagg" do
    action :disable
end

# try to stop the service, but allow a failure without printing the error
service "topagg" do
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