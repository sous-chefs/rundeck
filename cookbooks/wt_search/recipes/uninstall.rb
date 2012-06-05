# Cookbook Name:: roadrunner
# Recipe:: uninstall
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls existing RoadRunner installs.

# destinations
install_dir = "#{node['wt_common']['install_dir_windows']}#{node['wt_roadrunner']['install_dir']}"

# get data bag items
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['loader_user']

# determine root drive of install_dir - ENG390500
if (install_dir =~ /^(\w:)\\.*$/)
	install_dir_drive = $1
end

sc_cmd = "\"%WINDIR%\\System32\\sc.exe delete \"#{node['wt_roadrunner']['service_name']}\""
netsh_cmd = "netsh http delete urlacl url=http://+:8097/"

service node['wt_roadrunner']['service_name'] do
	action :stop
	ignore_failure true
end

execute "sc" do
	command sc_cmd
	ignore_failure true
end

# delete service with old service name
execute "sc" do
	command "\"%WINDIR%\\System32\\sc.exe delete \"WebtrendsRoadRunnerService\""
	ignore_failure true
end

execute "netsh" do
	command netsh_cmd
	ignore_failure true
end

# delete install folder
directory install_dir do
	recursive true
	action :delete
end

# remove service account from root directory - ENG390500
wt_base_icacls install_dir_drive do
	action :remove
	user svcuser
end

# remove firewall rule
execute "netsh" do
	command "netsh advfirewall firewall delete rule name=\"Webtrends RoadRunner port 8097\""
	ignore_failure true
end

unshare_wrs
