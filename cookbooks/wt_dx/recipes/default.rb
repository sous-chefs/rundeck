#
# Cookbook Name:: wt_dx
# Recipe:: default
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe sets up the base configuration for DX

if deploy_mode? 
  include_recipe "wt_dx::uninstall" 
  include_recipe "ms_dotnet4::regiis"  
end

#Properties
install_dir = node['wt_common']['install_dir_windows']
install_logdir = node['wt_common']['install_log_dir_windows']
cfg_cmds = node['wt_dx']['cfg_cmd']
pod = node.chef_environment
user_data = data_bag_item('authorization', pod)
ui_user = user_data['wt_common']['ui_user']
ui_password = user_data['wt_common']['ui_pass']
msi_name = node['wt_dx']['commonlib_msi']

#v21 Properties
cfg_cmds_v21 = node['wt_dx']['v2_1']['cfg_cmd']
app_pool_v21 = node['wt_dx']['v2_1']['app_pool']
install_dir_v21 = "#{node['wt_common']['install_dir_windows']}#{node['wt_dx']['v2_1']['dir']}"
auth_cmd_v21 = "/section:applicationPools /[name='#{app_pool_v21}'].processModel.identityType:SpecificUser /[name='#{app_pool_v21}'].processModel.userName:#{ui_user} /[name='#{app_pool_v21}'].processModel.password:#{ui_password}"

#v3 Properties
cfg_cmds_v3 = node['wt_dx']['v3']['cfg_cmd']
streamingservices_pool = node['wt_dx']['v3']['streamingservices']['app_pool']
webservices_pool = node['wt_dx']['v3']['webservices']['app_pool']
install_dir_v3 = "#{node['wt_common']['install_dir_windows']}#{node['wt_dx']['v3']['dir']}"
streamingauth_cmd = "/section:applicationPools /[name='#{streamingservices_pool}'].processModel.identityType:SpecificUser /[name='#{streamingservices_pool}'].processModel.userName:#{ui_user} /[name='#{streamingservices_pool}'].processModel.password:#{ui_password}"
webauth_cmd = "/section:applicationPools /[name='#{webservices_pool}'].processModel.identityType:SpecificUser /[name='#{webservices_pool}'].processModel.userName:#{ui_user} /[name='#{webservices_pool}'].processModel.password:#{ui_password}"

directory install_logdir do
	action :create
end

directory install_dir_v21 do
	action :create
	recursive true
end

directory install_dir_v3 do
	action :create
	recursive true
end

iis_pool app_pool_v21 do
  	thirty_two_bit :true
    action [:add, :config]
end

iis_site 'Default Web Site' do
	action [:stop, :delete]
end

iis_site 'DX' do
	protocol :http
    port 80
    path "#{node['wt_common']['install_dir_windows']}\\Data Extraction API"
	action [:add,:start]
end

iis_site 'OEM_DX' do
	protocol :http
    port 81
    path "#{node['wt_common']['install_dir_windows']}\\OEM Data Extraction API"
	action [:add,:start]
end

wt_base_firewall 'DXWS' do
	protocol "TCP"
	port 80
	action [:open_port]
end

wt_base_firewall 'OEM_DXWS' do
	protocol "TCP"
	port 81
	action [:open_port]
end

if deploy_mode?  
  windows_zipfile "#{Chef::Config[:file_cache_path]}" do
    source node['wt_dx']['download_url']
    action :unzip	
  end
  
  windows_package "WebTrends Common Lib" do
    source "#{Chef::Config[:file_cache_path]}\\#{msi_name}"
	options "/l*v \"#{install_logdir}\\#{msi_name}-Install.log\" INSTALLDIR=\"#{install_dir}\" SQL_SERVER_NAME=\"#{node['wt_common']['master_host']}\" WTMASTER=\"wtMaster\"  WTSCHED=\"wt_Sched\""
	action :install
  end
  
  template "#{install_dir_v21}\\web.config" do
  	source "webConfigv21.erb"
  	variables(
  		:cache_hosts => search(:node, "chef_environment:#{node.chef_environment} AND role:memcached")
  	)
  end  
  
  iis_app "DX" do
  	path "/v2_1"
  	application_pool app_pool_v21
  	physical_path install_dir_v21
  	action :add
  end
  
  iis_config auth_cmd_v21 do
  	action :config
  end

  execute "Movev3" do
    command "cp -r #{Chef::Config[:file_cache_path]}\\v3 \"#{install_dir_v3}\""
    action :run
  end
  
  template "#{install_dir_v3}\\StreamingServices\\Web.config" do
  	source "webConfigv3Streaming.erb"
  	variables(
  		:cache_hosts => search(:node, "chef_environment:#{node.chef_environment} AND role:memcached"),
  		:master_host => node['wt_common']['master_host']
  	)
  end
  
  search_server = search(:node, "chef_environment:#{node.chef_environment} AND role:wt_search")
  search_host = "#{search_server[0][:fqdn]}"
  
  template "#{install_dir_v3}\\Web Services\\Web.config" do
  	source "webConfigv3Web.erb"
  	variables(
  		:cache_hosts => search(:node, "chef_environment:#{node.chef_environment} AND role:memcached"),
  		:cassandra_hosts => node['wt_common']['cassandra_hosts'],
  		:master_host => node['wt_common']['master_host'],
  		:report_col => node['wt_common']['cassandra_report_column'],
  		:metadata_col => node['wt_common']['cassandra_meta_column'],
  		:snmp_comm => node['wt_common']['cassandra_snmp_comm'],
  		:cache_name => node['wt_dx']['cachename'],
  		:endpoint_address => "net.tcp://#{search_host}:8096/SearchService/Search",
  		:streamingservice_root => node['wt_dx']['app_settings_section']['streamingServiceRoot']
  	)
  end
  
  iis_pool "#{streamingservices_pool}" do
  	pipeline_mode :Integrated
    action [:add, :config]
  end
  
  iis_pool "#{webservices_pool}" do
  	pipeline_mode :Integrated
  	runtime_version "4.0"
    action [:add, :config]
  end
  
  iis_app "DX" do
  	path "/StreamingServices_v3"
  	application_pool "#{streamingservices_pool}"
  	physical_path "#{install_dir_v3}\\StreamingServices"
  	action :add
  end
  
  iis_app "DX" do
  	path "/v3"
  	application_pool "#{webservices_pool}"
  	physical_path "#{install_dir_v3}\\Web Services"
  	action :add
  end
  
  iis_config streamingauth_cmd do
  	action :config
  end
  
  iis_config webauth_cmd do
  	action :config
  end
  
  #DX 2.0 really just uses the DX 2.1 installations
  iis_app "DX" do
  	path "/v2"
  	application_pool "#{app_pool_v21}"
  	physical_path "#{install_dir_v21}"
  	action :add
  end 
  
  #DX 2.2 just uses the DX 3.0 installation
  iis_app "OEM_DX" do
  	path "/v2_2"
  	application_pool streamingservices_pool
  	physical_path "#{install_dir_v3}"
  	action :add
  end
  
  cfg_cmds.each do |cmd|	
    iis_config "#{cmd}" do
		action :config
	end
  end	
end

#Post Install

wt_base_icacls "#{install_dir}" do
	action :grant
	user user_data['wt_common']['ui_user']
	perm :read
end

wt_base_icacls node['wt_common']['install_dir_windows'] do
	action :grant
	user user_data['wt_common']['ui_user']
	perm :read
end

execute "ServiceModelReg" do
        command "%WINDIR%\\Microsoft.Net\\Framework64\\v4.0.30319\\ServiceModelReg.exe -r"
        action :run
end
