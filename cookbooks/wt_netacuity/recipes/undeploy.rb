#
# Cookbook Name:: wt_netacuity
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

service "netacuity" do
    action [:stop, :disable]
end 

directory "#{node['wt_netacuity']['install_dir']}" do
  recursive true
  action :delete
end