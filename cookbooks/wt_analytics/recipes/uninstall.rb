#
# Cookbook Name:: wt_analytics
# Recipe:: uninstall
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls all DX versions

app_pool = node['wt_analytics']['app_pool']
install_dir = node['wt_common']['install_dir_windows'] + node['wt_analytics']['install_dir']

iis_pool app_pool do
  action [:stop, :delete]
  ignore_failure true
end

iis_site 'Analytics' do
	action [:stop, :delete]
	ignore_failure true
end

directory install_dir do
  recursive true
  action :delete
  ignore_failure true
end