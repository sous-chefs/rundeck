#
# Cookbook Name:: wt_dx
# Recipe:: uninstall
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls all DX versions

app_pool = node['wt_cam']['camlite_app_pool']
install_dir = "#{node['wt_common']['install_dir_windows']}\\CAMLITE"

iis_app "CAMLITE" do
	path "/CamService"
	application_pool "#{app_pool}"
	action :delete
end

iis_pool "#{app_pool}" do
  action [:stop, :delete]
end

iis_site 'CAMLITE' do
	action [:stop, :delete]
end

directory "#{install_dir}" do
  recursive true
  action :delete
end
