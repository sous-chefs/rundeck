# Cookbook Name:: wt_sync
# Recipe:: uninstall
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends, Inc
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls existing Search Service installs

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_sync']['install_dir']).gsub(/[\\\/]+/,"\\")
log_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_sync']['log_dir']).gsub(/[\\\/]+/,"\\")

# get data bag items
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']

# determine root drive of install_dir - ENG390500
if (install_dir =~ /^(\w:)\\.*$/)
	install_dir_drive = $1
end

sc_cmd = "\"%WINDIR%\\System32\\sc.exe\" delete \"#{node['wt_sync']['service_name']}\""

service node['wt_sync']['service_name'] do
	action :stop
	ignore_failure true
end

# delays to give the service plenty of time to actually stop
ruby_block "wait" do
	block do
		sleep(120)
	end
	action :create
end

powershell "verify service removal" do
  code <<-EOH
	$WtServices = get-wmiobject -query 'select * from win32_service Where DisplayName Like "%Webtrends%"'
	Foreach ($Service in $WtServices){ 
    If ($Service){Stop-Process -Processname ($Service.Pathname -Replace ".*\\\\","" -Replace ".exe","") -Force -ErrorAction SilentlyContinue}
	}
	EOH
end

execute "sc" do
	command sc_cmd
	ignore_failure true
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

# remove service account from root directory - ENG390500
wt_base_icacls install_dir_drive do
	action :remove
	user svcuser
end
