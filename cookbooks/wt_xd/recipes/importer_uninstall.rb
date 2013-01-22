# Cookbook Name:: wt_xd
# Recipe:: uninstall
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends, Inc
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls existing Search Service installs

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_xd']['importer']['install_dir']).gsub(/[\\\/]+/,"\\")
log_dir = node['wt_common']['install_dir_windows']


# determine root drive of install_dir - ENG390500
if (install_dir =~ /^(\w:)\\.*$/)
	install_dir_drive = $1
end

xd_rs_cmd = "\"%WINDIR%\\System32\\sc.exe\" delete \"#{node['wt_xd']['retrieval']['service_name']}\""
xd_ss_cmd = "\"%WINDIR%\\System32\\sc.exe\" delete \"#{node['wt_xd']['storage']['service_name']}\""

service node['wt_xd']['retrieval']['service_name'] do
	action :stop
	ignore_failure true
end

service node['wt_xd']['storage']['service_name'] do
	action :stop
	ignore_failure true
end

# delays to give the service plenty of time to actually stop
ruby_block "wait" do
	block do
		sleep(120)		
	end
	action :create
end

execute "xd_rs_cmd" do
	command xd_rs_cmd
	ignore_failure true
end

execute "xd_ss_cmd" do
	command xd_ss_cmd
	ignore_failure true
end

# delete install folder
directory install_dir do
	recursive true
	action :delete
end

# delete log folder
directory log_dir do
	recursive true
	action :delete
end