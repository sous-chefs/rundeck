#
# Cookbook Name:: wt_devicedataupdater
# Recipe:: uninstall
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_devicedataupdater']['install_dir']).gsub(/[\\\/]+/,"\\")

# full path to DDU.exe
ddu = File.join(install_dir, node['wt_devicedataupdater']['service_binary']).gsub(/[\\\/]+/,"\\")
execute "#{node['wt_devicedataupdater']['service_binary']} uninstall" do
  command "#{ddu} -uninstall"
  ignore_failure true
  only_if { File.exists?(ddu) }
end

# delete install folder
directory install_dir do
  recursive true
  action :delete
end

unshare_wrs