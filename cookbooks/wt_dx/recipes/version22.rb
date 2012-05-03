#
# Cookbook Name:: wt_dx
# Recipe:: version22
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe sets DX 2.2

#DX 2.2 just uses the DX 3.0 installation
cfg_cmds = node['wt_dx']['v3']['cfg_cmd']
app_pool = node['wt_dx']['v3']['web_services']['app_pool']
installdir = node['wt_common']['installdir_windows']
installdir_v22 = node['wt_dx']['v3']['dir']

iis_app "OEM_DX" do
	path "/v2_2"
	application_pool "#{app_pool}"
	physical_path "#{installdir}#{installdir_v22}"
	action :add
end