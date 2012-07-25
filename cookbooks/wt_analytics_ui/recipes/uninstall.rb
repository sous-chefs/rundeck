#
# Cookbook Name:: wt_analytics_ui
# Recipe:: uninstall
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

app_pool = node['wt_analytics_ui']['app_pool_name']
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_analytics_ui']['install_dir']).gsub(/[\\\/]+/,"\\")

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
end

