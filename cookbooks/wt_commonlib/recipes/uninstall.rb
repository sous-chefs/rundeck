#
# Cookbook Name:: wt_commonlib
# Recipe:: uninstall
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the needed components to prepare machine for db_index exe

logdir = node['wt_common']['log_dir_windows']
msi_name = node['wt_commonlib']['commonlib_msi']

directory logdir do
	action :create
	recursive true
end

windows_package "WebTrends Common Lib" do
  source "#{Chef::Config[:file_cache_path]}\\#{msi_name}"
  options "/l*v \"#{logdir}\\#{msi_name}-Uninstall.log\""
  action :remove
end