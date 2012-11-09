# Cookbook Name:: wt_logpreproc
# Recipe:: uninstall
# Author:: Jeremy Chartrand
#
# Copyright 2012, Webtrends, Inc
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls existing Log Preprocessor installs

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_logpreproc']['install_dir'].gsub(/[\\\/]+/,"\\"))
log_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_logpreproc']['log_dir'].gsub(/[\\\/]+/,"\\"))

# get data bag items
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']

logpreproc = File.join(install_dir, node['wt_logpreproc']['service_binary']).gsub(/[\\\/]+/,"\\")
execute "#{node['wt_logpreproc']['service_binary']} uninstall" do
  command "#{logpreproc} --uninstall"
  only_if { File.exists?(logpreproc) }
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
