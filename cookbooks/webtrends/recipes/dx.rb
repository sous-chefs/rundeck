#
# Cookbook Name:: webtrends
# Recipe:: dx
# Author: Kendrick Martin
#
# Copyright 2011, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the needed components to full setup/configure DX.

#include_recipe "iis"
#include_recipe "windows"
require 'cgi'

buildURLs = data_bag("buildURLs")
build_url = data_bag_item('buildURLs', 'latest')
base_url = build_url['url'] + "/dx/DX_2.2"
dx_msi_url = base_url + node['webtrends']['dx']['msi_name']
dx_msi_name = CGI::unescape(::File.basename(dx_msi_url))
common_msi_name = CGI::unescape(::File.basename(node['webtrends']['common_url']))
common_msi_short = "WebTrendsCommonLib.msi"
dir_list = node['dx']['dx_dir']
cfg_cmds = node['iis']['cfg_cmd']
legacy_app_pools = node['dx']['legacy_app_pool']
app_pools = node['dx']['app_pool']

directory "#{node['dx']['msi_path']}" do
	action [:create]
	recursive true
end

directory "D:\\logs" do
	action :create
end

remote_file "#{node['dx']['msi_path']}\\#{dx_msi_name}" do
	source dx_msi_url
	action :nothing
end

remote_file "#{node['dx']['msi_path']}\\#{common_msi_short}" do
	source node['webtrends']['common_url']
	action :nothing
end

http_request "HEAD #{node['dx']['base_url']}" do
  message ""
  url node['dx']['base_url']
  action :head
  if File.exists?("#{node['dx']['msi_path']}\\#{dx_msi_name}")
    headers "If-Modified-Since" => File.mtime("#{node['dx']['msi_path']}\\#{dx_msi_name}").httpdate
  end
  notifies :create, resources(:remote_file => "#{node['dx']['msi_path']}\\#{dx_msi_name}"), :immediately
end

http_request "HEAD #{node['webtrends']['base_url']}" do
  message ""
  url node['webtrends']['base_url']
  action :head
  if File.exists?("#{node['dx']['msi_path']}\\#{common_msi_name}")
    headers "If-Modified-Since" => File.mtime("#{node['dx']['msi_path']}\\#{common_msi_name}").httpdate
  end
  notifies :create, resources(:remote_file => "#{node['dx']['msi_path']}\\#{common_msi_short}"), :immediately
end

windows_registry 'HKLM\Software\WebTrends Corporation' do
	values 'isHosted' => 1, 'IsHostedAdToggle' => 1
	action [:create]
end

windows_registry 'HKLM\SOFTWARE\Wow6432Node\WebTrends Corporation' do
	values 'isHosted' => 1, 'IsHostedAdToggle' => 1
	action [:create]
end

dir_list.each do |dir|
	directory "D:\\wrs\\#{dir}" do
		action [:create]
		recursive true
	end
end

cfg_cmds.each do |cmd|	
	iis_config "#{cmd}" do
		action :config
	end
end

# stop and delete the default site
iis_site 'Default Web Site' do
	action [:stop, :delete]
end

iis_site 'DX' do
	protocol :http
    port 80
    path "#{node['dx']['site_path']}"
	action [:add,:start]
end

legacy_app_pools.each do |pool|
	iis_pool "#{pool}" do
		thirty_two_bit :true
		action [:add, :config]
	end
end

app_pools.each do |pool|
	iis_pool "#{pool}" do	
		pipeline_mode :Integrated
		action [:add, :config]
	end
end

windows_firewall 'DXWS' do
	protocol "TCP"
	port 80
	action [:open_port]
end

windows_firewall 'OEM_DXWS' do
	protocol "TCP"
	port 81
	action [:open_port]
end

windows_package "CommonLib" do
	source "#{node['dx']['msi_path']}\\#{common_msi_short}"
	options "/l*v \"D:\\logs\\Install - Webtrends Commonlib.log\" INSTALLDIR=\"D:\\wrs\" SQL_SERVER_NAME=\"kmasterdb01\" WTMASTER=\"wt_master\" MASTER_USER=\"#{user}\" MASTER_PASS=\"#{pass}\" WTSCHED=\"localhost\" SCHED_USER=\"#{user}\" SCHED_PASS=\"#{pass}\""
	action :install
end