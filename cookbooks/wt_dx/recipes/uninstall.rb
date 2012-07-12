#
# Cookbook Name:: wt_dx
# Recipe:: uninstall
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls all DX versions

v21pool = node['wt_dx']['v2_1']['app_pool']
streamingservices_pool = node['wt_dx']['v3']['streamingservices']['app_pool']
webservices_pool = node['wt_dx']['v3']['webservices']['app_pool']
dx_dir = "#{node['wt_common']['installdir']}\\Data Extraction API"
oem_dir = "#{node['wt_common']['installdir']}\\OEM Data Extraction API"
logdir = node['wt_common']['log_dir_windows']
msi_name = node['wt_dx']['commonlib_msi']

directory logdir do
	action :create
	recursive true
end

windows_package "WebTrends Common Lib" do
        source "#{Chef::Config[:file_cache_path]}\\#{msi_name}"
        options "/l*v \"#{logdir}\\#{msi_name}-Uninstall.log\""
        action :remove
end

iis_config "/section:httpCompression /-\"[name='deflate',doStaticCompression='True',doDynamicCompression='True',dll='c:\\windows\\system32\\inetsrv\\gzip.dll']\" /commit:apphost" do
	action :config
  end

iis_app "DX" do
	path "/v2"
	application_pool "#{v21pool}"
	action :delete
end

iis_app "DX" do
	path "/v2_1"
	application_pool "#{v21pool}"
	action :delete
end

iis_pool "#{v21pool}" do
  action [:stop, :delete]
end

iis_app "OEM_DX" do
	path "/v2_2"
	application_pool streamingservices_pool
	action :delete
end


iis_app "DX" do
	path "/StreamingServices_v3"
	application_pool "#{streamingservices_pool}"
	action :delete
end

iis_app "DX" do
	path "/v3"
	application_pool "#{webservices_pool}"
	action :delete
end

iis_pool "#{streamingservices_pool}" do
	action [:stop, :delete]
end

iis_pool "#{webservices_pool}" do
	action [:stop, :delete]
end

iis_site 'DX' do
	action [:stop, :delete]
end

iis_site 'OEM_DX' do
	action [:stop, :delete]
end

execute "iisreset" do
	command "iisreset"
end

directory "#{dx_dir}" do
  recursive true
  action :delete
end

directory "#{oem_dir}" do
  recursive true
  action :delete
end