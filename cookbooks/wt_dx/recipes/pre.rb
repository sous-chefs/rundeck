#
# Cookbook Name:: wt_dx
# Recipe:: pre
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe sets up the base configuration for DX

installdir = node['wt_common']['install_dir_windows']
install_logdir = node['wt_common']['install_logdir_windows']
cfg_cmds = node['wt_dx']['cfg_cmd']

directory install_logdir do
	action :create
end

ruby_block "deflate_flag" do
	Chef::Log.info("i am in deflate_flag") 
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