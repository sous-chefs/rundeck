#
# Cookbook Name:: wt_dx
# Recipe:: uninstall
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls all DX versions

app_pool = node['wt_cam']['app_pool']
install_dir = "#{node['wt_common']['install_dir_windows']}\\Webtrends.Cam"

# remove the app
iis_app 'CAM' do
	path "/Cam"
	application_pool "#{app_pool}"
	action :delete
end

# remove the site
iis_site 'CAM' do
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
