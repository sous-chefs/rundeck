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

execute "Uninstall retrieval service" do
	command "#{install_dir}\\#{node['wt_xd']['retrieval']['service_binary']} --uninstall"
	ignore_failure true
end

execute "Uninstall storage service" do
	command "#{install_dir}\\#{node['wt_xd']['storage']['service_binary']} --uninstall"
	ignore_failure true
end

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
