#
# Cookbook Name:: webtrends
# Recipe:: dx
# Author: Kendrick Martin
#
# Copyright 2011, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the needed components to full setup/configure DX.

installdir = node['webtrends']['installdir']
logdir = node['webtrends']['logdir']
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

iis_site 'OEM_DX' do
	protocol :http
    port 81
    path "#{installdir}\\OEM Data Extraction API"
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