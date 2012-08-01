#
# Cookbook Name:: wt_cam
# Recipe:: uninstall
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls the Auth component of CAM

app_pool = node['wt_cam']['app_pool']
install_dir = "#{node['wt_common']['install_dir_windows']}\\Webtrends.Auth"

# remove the app
iis_app 'AUTH' do
	path "/Auth"
	application_pool "#{app_pool}"
	action :delete
end

# remove the site
iis_site 'AUTH' do
	action [:stop, :delete]
end

# remove the pool
iis_pool "#{app_pool}" do
    action [:stop, :delete]
    # ignore errors for now since the resource search will match CAMService when searching for CAM
    ignore_failure true 
end

directory "#{install_dir}" do
  recursive true
  action :delete
end
