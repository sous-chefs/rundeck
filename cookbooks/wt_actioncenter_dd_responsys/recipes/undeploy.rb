#
# Cookbook Name:: wt_actioncenter_dd_responsys
# Recipe:: undeploy
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

install_dir  = File.join(node['wt_portfolio_harness']['plugin_dir'], "responsys")

directory install_dir do
  recursive true
  action :delete
end
