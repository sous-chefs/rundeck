#
# Cookbook Name:: wt_dx
# Recipe:: pre
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe sets up the base configuration for DX

log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] == "true" then 
  include_recipe "wt_dx::uninstall" 
end


#Properties
install_dir = node['wt_common']['install_dir_windows']
install_logdir = node['wt_common']['install_logdir_windows']
cfg_cmds = node['wt_dx']['cfg_cmd']
pod = node.chef_environment
user_data = data_bag_item('authorization', pod)
ui_user = user_data['wt_common']['ui_user']
ui_password = user_data['wt_common']['ui_pass']
endpoint = node['wt_dx']['endpoint_address']
cass_hosts = node['wt_common']['cassandra_hosts'].map {|x| "Name:" + x}
cass_hosts = "{#{cass_hosts.to_json}}"
c_hosts = cache_hosts = search(:node, "chef_environment:#{node.chef_environment} AND recipes:memcached")

#v21 Properties
cfg_cmds_v21 = node['wt_dx']['v2_1']['cfg_cmd']
app_pool_v21 = node['wt_dx']['v2_1']['app_pool']
install_dir_v21 = "#{node['wt_common']['installdir_windows']}#{node['wt_dx']['v21']['dir']}"
auth_cmd_v21 = "/section:applicationPools /[name='#{app_pool_v21}'].processModel.identityType:SpecificUser /[name='#{app_pool_v21}'].processModel.userName:#{ui_user} /[name='#{app_pool_v21}'].processModel.password:#{ui_password}"

#v3 Properties
cfg_cmds_v3 = node['wt_dx']['v3']['cfg_cmd']
streamingservices_pool = node['wt_dx']['v3']['streamingservices']['app_pool']
webservices_pool = node['wt_dx']['v3']['webservices']['app_pool']
install_dir_v3 = "#{node['wt_common']['installdir_windows']}#{node['wt_dx']['v3']['dir']}"
streamingauth_cmd = "/section:applicationPools /[name='#{streamingservices_pool}'].processModel.identityType:SpecificUser /[name='#{streamingservices_pool}'].processModel.userName:#{ui_user} /[name='#{streamingservices_pool}'].processModel.password:#{ui_password}"
webauth_cmd = "/section:applicationPools /[name='#{webservices_pool}'].processModel.identityType:SpecificUser /[name='#{webservices_pool}'].processModel.userName:#{ui_user} /[name='#{webservices_pool}'].processModel.password:#{ui_password}"

directory install_logdir do
	action :create
end

ruby_block "deflate_flag" do 
	block do
		node.default['deflate'] = "configured"
		node.save
	end
	action :nothing
end

iis_config "/section:httpCompression /+\"[name='deflate',doStaticCompression='True',doDynamicCompression='True',dll='c:\\windows\\system32\\inetsrv\\gzip.dll']\" /commit:apphost" do
	action :config
	notifies :create, "ruby_block[deflate_flag]", :immediately
	not_if {node.attribute?("deflate")}
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

iis_site 'OEM_DX' do
	protocol :http
    port 81
    path "#{installdir}\\OEM Data Extraction API"
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

if ENV["deploy_build"] == "true" then 
  ##################################
  # DX V2_1
  ##################################
  windows_zipfile "#{installdir}#{v21_installdir}" do
    source "#{archive_url}#{v21_install_url}"
    action :unzip	
  end
  
  template "#{install_dir_v21}\\web.config" do
  	source "webConfigv21.erb"
  	variables(
  		:cache_hosts => c_hosts
  	)
  end
  
  iis_pool "#{app_pool_v21}" do
  	thirty_two_bit :true
  action [:add, :config]
  end
  
  iis_app "DX" do
  	path "/v2_1"
  	application_pool "#{app_pool_v21}"
  	physical_path "#{install_dir_v21}"
  	action :add
  end
  
  iis_config auth_cmd_v21 do
  	action :config
  end
  
  ##################################
  # DX V3
  ##################################
  windows_zipfile "#{installdir}#{v3_installdir}" do
    source "#{install_url}#{v3_install_url}"
    action :unzip	
    not_if {::File.exists?("#{installdir}#{v3_installdir}\\StreamingServices\\log4net.config")}
  end
  
  template "#{install_dir_v3}\\StreamingServices\\Web.config" do
  	source "webConfigv3Streaming.erb"
  	variables(
  		:cache_hosts => c_hosts,
  		:master_host => node['wt_common']['master_host']
  	)
  end
  
  template "#{install_dir_v3}\\Web Services\\Web.config" do
  	source "webConfigv3Web.erb"
  	variables(
  		:cache_hosts => c_hosts,
  		:cassandra_hosts => node['wt_common']['cassandra_hosts'],
  		:master_host => node['wt_common']['master_host'],
  		:report_col => node['wt_common']['cassandra_report_column'],
  		:metadata_col => node['wt_common']['cassandra_meta_column'],
  		:snmp_comm => node['wt_common']['cassandra_snmp_comm'],
  		:cache_name => node['wt_dx']['cachename'],
  		:endpoint_address => node['wt_dx']['endpoint_address'],
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
  
  ##################################
  # DX V2
  ##################################
  #DX 2.0 really just uses the DX 2.1 installations
  iis_app "DX" do
  	path "/v2"
  	application_pool "#{app_pool_v21}"
  	physical_path "#{install_dir_v21}"
  	action :add
  end
  
  ##################################
  # DX V2_2
  ##################################
  #DX 2.2 just uses the DX 3.0 installation
  iis_app "OEM_DX" do
  	path "/v2_2"
  	application_pool "#{app_pool_v3}"
  	physical_path "#{install_dir_v3}"
  	action :add
  end
end

#Post Install

execute "icacls" do
        command "icacls \"#{node['wt_common']['installdir_windows']}\\Data Extraction API\" /grant:r IUSR:(oi)(ci)(rx)"
        action :run
end

execute "icacls" do
        command "icacls \"#{node['wt_common']['installdir_windows']}\\OEM Data Extraction API\" /grant:r IUSR:(oi)(ci)(rx)"
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