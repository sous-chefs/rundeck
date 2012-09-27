# Cookbook Name:: wt_devicedataupdater
# Recipe:: uninstall
# Author:: Tim Smith
#
# Copyright 2012, Webtrends, Inc.
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls existing RoadRunner installs.

# destinations
install_dir = "#{node['wt_common']['install_dir_windows']}#{node['wt_devicedataupdater']['install_dir']}"

# determine root drive of install_dir - ENG390500
if (install_dir =~ /^(\w:)\\.*$/)
	install_dir_drive = $1
end

# delete install folder
directory install_dir do
	recursive true
	action :delete
end

unshare_wrs