#
# Cookbook Name:: wt_roadrunner
# Recipe:: uninstall
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends, Inc.
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls existing RoadRunner installs.

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_roadrunner']['install_dir']).gsub(/[\\\/]+/,"\\")

# get data bag items
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser   = auth_data['wt_common']['loader_user']

# determine root drive of install_dir - ENG390500
if (install_dir =~ /^(\w:)\\.*$/)
	install_dir_drive = $1
end

service node['wt_roadrunner']['service_name'] do
	action :stop
	ignore_failure true
end

execute 'sc' do
	command "sc delete \"#{node['wt_roadrunner']['service_name']}\""
	ignore_failure true
end

# delete service with old service name
execute 'sc' do
	command 'sc delete WebtrendsRoadRunnerService'
	ignore_failure true
end

execute 'netsh' do
	command 'netsh http delete urlacl url=http://+:8097/'
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
execute 'netsh' do
	command 'netsh advfirewall firewall delete rule name=\"Webtrends RoadRunner port 8097\"'
	ignore_failure true
end

unshare_wrs
