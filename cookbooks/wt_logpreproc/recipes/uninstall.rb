#
# Cookbook Name:: wt_logpreproc
# Recipe:: uninstall
# Author:: Jeremy Chartrand
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#
# This recipe uninstalls existing Log Preprocessor installs
#

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_logpreproc']['install_dir']).gsub(/[\\\/]+/,"\\")

# full path to service binary
svcbin = File.join(install_dir, node['wt_logpreproc']['service_binary']).gsub(/[\\\/]+/,"\\")

# stop service
service node['wt_logpreproc']['service_name'] do
	action :stop
	ignore_failure true
end

# sleep to allow service to stop
ruby_block 'wait' do
	block do
		sleep(10)
	end
end

execute "#{node['wt_logpreproc']['service_binary']} uninstall" do
  command "#{svcbin} --uninstall"
  only_if { File.exists?(svcbin) }
end

# delete install folder
directory install_dir do
	recursive true
	action :delete
end

