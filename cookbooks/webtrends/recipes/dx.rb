#
# Cookbook Name:: webtrends
# Recipe:: dx
# Author: Kendrick Martin
#
# Copyright 2011, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the needed components to full setup/configure DX.
 
# require 'cgi'


#######################################################################################
#TODO                                                                                 #
#Split the app_settings, cass_hosts, and cache_hosts into JSON parsed from data bags  #
#Add c++ prerequsite to the recipe                                                    #
#Copy DX for versions <V3 and creates sites in iis                                    #
#Fix DX v3 installer to not install multiple times                                    #
#Add ability to parse through the iis config for a specific value                     #
#######################################################################################

pod = node['webtrends']['pod']
pods = data_bag("pods")
pod_data = data_bag_item('pods', pod)
master_host = pod_data['master_host']
user = node['user']
pass = node['pass']

installdir = node['webtrends']['installdir']
logdir = node['webtrends']['logdir']

cache_name = pod_data['dx']['cachename']
cass_snmp = pod_data['cassandra_snmp_comm']
cass_report_family = pod_data['cassandra_report_column']
cass_metadata_family = pod_data['cassandra_meta_column']
app_settings = pod_data['dx']['app_settings_section']
endpoint = pod_data['dx']['endpoint_address']

app_settings = "[{'streamingServiceRoot':'https://fdx.webtrends.com/StreamingServices_v3/'}]"
cass_hosts = "[{Name:'scass01.staging.dmz'},{Name:'scass02.staging.dmz'}, {Name:'scass03.staging.dmz'}, {Name:'scass04.staging.dmz'}]"
cache_hosts = "[{Name:'xcache01.staging.dmz', Port:'11211'},{Name:'xcache02.staging.dmz', Port:'11211'}]"

common_msi = node['webtrends']['common_msi']
dx_msi = node['webtrends']['dx']['dx_msi']
buildURLs = data_bag("buildURLs")
build_url = data_bag_item('buildURLs', 'latest')
dx_msi_url = build_url['url']
dx_msi_url << "dx/"
dx_msi_url << dx_msi


build_url = data_bag_item('buildURLs', 'latest')
common_msi_url = build_url['url']
common_msi_url << common_msi
build_url = data_bag_item('buildURLs', 'latest')
base_url = build_url['url']
app_user = pod_data['ui_acct']
app_pass = pod_data['ui_pass'] 

dir_list = node['webtrends']['dx']['dx_dir']
cfg_cmds = node['webtrends']['dx']['cfg_cmd']
legacy_app_pools = node['webtrends']['dx']['legacy_app_pool']
app_pools = node['webtrends']['dx']['app_pool']

directory msi_path do
	action [:create]
	recursive true
end

directory logdir do
	action :create
end

remote_file "#{Chef::Config[:file_cache_path]}\\#{dx_msi}" do
	source dx_msi_url
	action :nothing
end

remote_file "#{Chef::Config[:file_cache_path]}\\#{common_msi}" do
	source common_msi_url
	action :nothing
end

http_request "HEAD #{base_url}" do
  message ""
  url base_url
  action :head
  if File.exists?("#{Chef::Config[:file_cache_path]}\\#{dx_msi}")
    headers "If-Modified-Since" => File.mtime("#{Chef::Config[:file_cache_path]}\\#{dx_msi}").httpdate
  end
  notifies :create, resources(:remote_file => "#{Chef::Config[:file_cache_path]}\\#{dx_msi}"), :immediately
end

http_request "HEAD #{base_url}" do
  message ""
  url base_url
  action :head
  if File.exists?("#{Chef::Config[:file_cache_path]}\\#{common_msi}")
    headers "If-Modified-Since" => File.mtime("#{Chef::Config[:file_cache_path]}\\#{common_msi}").httpdate
  end
  notifies :create, resources(:remote_file => "#{Chef::Config[:file_cache_path]}\\#{common_msi}"), :immediately
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

iis_site 'Default Web Site' do
	action [:stop, :delete]
end

iis_site 'DX' do
	protocol :http
    port 80
    path "#{installdir}\\Data Extraction API"
	action [:add,:start]
end

legacy_app_pools.each do |pool|
	iis_pool "#{pool}" do
		thirty_two_bit :true
		action [:add, :config]
	end
	cmd = pool + "-section:system.webServer/handlers /+\"[name='svc-ISAPI-2.0_32bit',path='*.SVC',verb='*',modules='IsapiModule',scriptProcessor='C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727\\aspnet_isapi.dll']\""
	iis_config cmd do
		:config
	end
end

app_pools.each do |pool|
	iis_pool "#{pool}" do	
		pipeline_mode :Integrated
		action [:add, :config]
	end
	cmd = pool + "-section:system.webServer/handlers /+\"[name='svc-ISAPI-2.0_32bit',path='*.SVC',verb='*',modules='IsapiModule',scriptProcessor='C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727\\aspnet_isapi.dll']\""
	iis_config cmd do
		:config
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
	source "#{Chef::Config[:file_cache_path]}\\#{common_msi}"
	options "/l*v \"#{logdir}\\#{common_msi}-Install.log\" INSTALLDIR=\"#{installdir}\" SQL_SERVER_NAME=\"#{master_host}\" WTMASTER=\"wtMaster\"  WTSCHED=\"wt_Sched\""
	action :install
end

windows_package "DXInstall" do
	source "#{Chef::Config[:file_cache_path]}\\#{dx_msi}"
	options "/l*v \"#{logdir}\\#{dx_msi}-Install.log\" INSTALLDIR=\"#{installdir}\" WEBSITE_NAME=\"DX\" MASTER_HOST=\"#{master_host}\" WEBSITE_PORT=\"80\" APP_POOL_ACCT=\"#{app_user}\" APP_POOL_PASS=\"#{app_pass}\" CACHEENABLED=\"True\" CACHENAME=\"#{cache_name}\" CACHE_HOSTS=\"#{cache_hosts}\" CASSANDRA_HOSTNAME=\"#{cass_hosts}\" CASSANDRA_SNMP_COMM=\"#{cass_snmp}\" CASSANDRA_REPORT_FAMILY=\"#{cass_report_family}\" CASSANDRA_METADATA_FAMILY=\"#{cass_metadata_family}\" APP_SETTINGS_SECTION=\"#{app_settings}\" ENDPOINT_ADDRESS=#{endpoint} LOG_DIR=#{logdir}"
	action :install
end

execute "icacls" do
	command "icacls \"#{installdir}\\Data Extraction API\" /grant:r IUSR:(oi)(ci)(rx)"
	action :run
end

execute "icacls" do
	command "icacls \"#{installdir}\\OEM Data Extraction API\" /grant:r IUSR:(oi)(ci)(rx)"
	action :run
end

execute "aspnet_regiis" do
	command "%WINDIR%\\Microsoft.Net\\Framework64\\v4.0.30319\\aspnet_regiis -i -enable"
	action :run
end

execute "ServiceModelReg" do
	command "%WINDIR%\\Microsoft.Net\\Framework64\\v4.0.30319\\ServiceModelReg.exe -r"
	action :run
end	