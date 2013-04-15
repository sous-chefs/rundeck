#
# Cookbook Name:: wt_actioncenter_ds_streaming
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#


install_dir  = File.join(File.join(node['wt_portfolio_harness']['plugin_dir'], "actioncenter_ds_streaming")

directory install_dir do
  recursive true
  action :delete
end
