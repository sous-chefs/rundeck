# Cookbook Name:: wt_search
# Recipe:: uninstall
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls existing Search Service installs

# destinations
install_dir = "#{node['wt_common']['install_dir_windows']}#{node['wt_search']['install_dir']}"

# get data bag items
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']

# determine root drive of install_dir - ENG390500
if (install_dir =~ /^(\w:)\\.*$/)
	install_dir_drive = $1
end

sc_cmd = "\"%WINDIR%\\System32\\sc.exe delete \"#{node['wt_search']['service_name']}\""

service node['wt_search']['service_name'] do
	action :stop
	ignore_failure true
end

execute "sc" do
	command sc_cmd
	ignore_failure true
end

ruby_block "wait" do
	block do
		sleep(60)
	end
	action :create
end

# delete install folder
directory install_dir do
	recursive true
	action :delete
end

# delete log folder
directory "#{node['wt_common']['install_dir_windows']}#{node['wt_search']['log_dir']}" do
	recursive true
	action :delete
end

# remove service account from root directory - ENG390500
wt_base_icacls install_dir_drive do
	action :remove
	user svcuser
end
