#
# Cookbook Name:: wt_dx
# Recipe:: version2
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe sets DX 2.0

#DX 2.0 really just uses the DX 2.1 installatinos
cfg_cmds = node['wt_dx']['v2_1']['cfg_cmd']
app_pool = node['wt_dx']['v2_1']['app_pool']
installdir = node['wt_common']['installdir_windows']
installdir_v2 = node['wt_dx']['v2_1']['dir']

iis_app "DX" do
	path "/v2"
	application_pool "#{app_pool}"
	physical_path "#{installdir}#{installdir_v2}"
	action :add
end