#
# Cookbook Name:: wt_data_deleter
# Recipe:: uninstall
# Author:: Michael Parsons
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_data_deleter']['install_dir']).gsub(/[\\\/]+/,"\\")
log_dir     = File.join(node['wt_common']['install_dir_windows'], node['wt_data_deleter']['log_dir']).gsub(/[\\\/]+/,"\\")

datadeleter = File.join(install_dir, node['wt_data_deleter']['datadeleter_binary']).gsub(/[\\\/]+/,"\\")
execute "#{node['wt_data_deleter']['datadeleter_binary']} uninstall" do
  command "#{datadeleter} --uninstall"
  only_if { File.exists?(datadeleter) }
end

deletionscheduler = File.join(install_dir, node['wt_data_deleter']['deletionscheduler_binary']).gsub(/[\\\/]+/,"\\")
execute "#{node['wt_data_deleter']['deletionscheduler_binary']} uninstall" do
  command "#{deletionscheduler} --uninstall"
  only_if { File.exists?(deletionscheduler) }
end

# delete install folder
directory install_dir do
  recursive true
  action :delete
end

unshare_wrs