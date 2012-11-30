#
# Cookbook Name:: wt_commonlib
# Recipe:: default
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the needed components to prepare machine for db_index exe

logdir = node['wt_common']['log_dir_windows']
installdir = node['wt_common']['install_dir_windows']
archive_url = node['wt_common']['archive_server']
master_host = node['wt_masterdb']['master_host']
common_install_url = node['wt_commonlib']['common_install_url']
msi_name = node['wt_commonlib']['commonlib_msi']

directory logdir do
	action :create
	recursive true
end

if ENV["deploy_build"] == "true" then 
	remote_file "#{Chef::Config[:file_cache_path]}\\#{msi_name}" do
		source "#{archive_url}#{common_install_url}"
		action :nothing
	end

	windows_package "WebTrends Common Lib" do
		source "#{Chef::Config[:file_cache_path]}\\#{msi_name}"
		options "/l*v \"#{logdir}\\#{msi_name}-Install.log\" INSTALLDIR=\"#{installdir}\" SQL_SERVER_NAME=\"#{master_host}\" WTMASTER=\"wtMaster\"  WTSCHED=\"wt_Sched\""
		action :install
	end
end