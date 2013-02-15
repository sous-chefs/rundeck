#
# Cookbook Name:: wt_xd_importer
# Recipe:: uninstall
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls existing Search Service installs

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_xd_importer']['install_dir']).gsub(/[\\\/]+/,"\\")
log_dir = node['wt_common']['install_dir_windows']


# determine root drive of install_dir - ENG390500
if (install_dir =~ /^(\w:)\\.*$/)
	install_dir_drive = $1
end

execute "Uninstall retrieval service" do
	command "#{install_dir}\\#{node['wt_xd_importer']['retrieval']['service_binary']} --uninstall"
	ignore_failure true
end

execute "Uninstall storage service" do
	command "#{install_dir}\\#{node['wt_xd_importer']['storage']['service_binary']} --uninstall"
	ignore_failure true
end

# DM: doesn't make sense to do this as agent is already removed along with configuration. It will just cause refresh to wait till timeout
#execute "Unregister from scheduler agent" do
#	command "#{install_dir}\\#{node['wt_xd_importer']['refresh']['binary']} --uninstall"
#	ignore_failure true
#	returns 21
#end

# delays to give the service plenty of time to actually stop
ruby_block "wait" do
	block do
		sleep(120)		
	end
	action :create
end

# delete install folder
directory install_dir do
	recursive true
	action :delete
end
