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

powershell "uninstall log preprocessor" do
	environment({'install_dir' => install_dir, 'service_binary' => node['wt_logpreproc']['logpreproc_binary']})
	code <<-EOH
        $binary_path = $env:install_dir + "\\" + $env:service_binary
	$binary_path_exists = Test-Path $binary_path
	if ($binary_path_exists) {
		&$binary_path --uninstall
	}	
	EOH
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
