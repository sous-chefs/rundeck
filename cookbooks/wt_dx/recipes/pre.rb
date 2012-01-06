#
# Cookbook Name:: webtrends
# Recipe:: dx
# Author: Kendrick Martin
#
# Copyright 2011, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the needed components to full setup/configure DX.


#######################################################################################
#TODO                                                                                 #
#Copy DX for versions <V3 and creates sites in iis                                    #
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
app_settings = "#{app_settings.to_json}"

endpoint = pod_data['dx']['endpoint_address']
cass_hosts = pod_data['cassandra_hosts'].map {|x| "Name:" + x}
cass_hosts = "{#{cass_hosts.to_json}}"

c_hosts = pod_data['cache_hosts']
cache_hosts = ""
c_hosts.each {|x| cache_hosts << x.to_json + ", "} #This still leaves one extra , at the eol fixed below
cache_hosts = "{#{cache_hosts}"
cache_hosts[-1] = "}" #Final } is replacing the last , in the string

#common_msi = node['webtrends']['common_msi']
#dx_msi = node['webtrends']['dx']['dx_msi']
buildURLs = data_bag("buildURLs")
build_url = data_bag_item('buildURLs', 'latest')
#dx_msi_url = build_url['url']
#dx_msi_url << "dx/"
#dx_msi_url << dx_msi

#common_msi_url = build_url['url']
#common_msi_url << common_msi

app_user = pod_data['ui_acct']
app_pass = pod_data['ui_pass'] 

cfg_cmds = node['webtrends']['dx']['cfg_cmd']

directory logdir do
	action :create
end

windows_registry 'HKLM\Software\WebTrends Corporation' do
	values 'isHosted' => 1, 'IsHostedAdToggle' => 1
	action [:create]
end

windows_registry 'HKLM\SOFTWARE\Wow6432Node\WebTrends Corporation' do
	values 'isHosted' => 1, 'IsHostedAdToggle' => 1
	action [:create]
end

ruby_block "deflate_flag" do
	block do
		node.set['deflate_configured']
		node.save
	end
	action :nothing
end

iis_config "/section:httpCompression /+\"[name='deflate',doStaticCompression='True',doDynamicCompression='True',dll='c:\\windows\\system32\\inetsrv\\gzip.dll']\" /commit:apphost" do
	action :config
	notifies :create, "ruby_block[deflate_flag]", :immediately
	not_if {node.attribute?("deflate_configured")}
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