# Cookbook Name:: wt_datadeleter
# Recipe:: uninstall
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends, Inc
#
# All rights reserved - Do Not Redistribute
# This recipe uninstalls existing Search Service installs

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_datadeleter']['install_dir'].gsub(/[\\\/]+/,"\\"))
log_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_datadeleter']['log_dir'].gsub(/[\\\/]+/,"\\"))

# get data bag items
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']

powershell "uninstall data deleter" do
  environment({'install_dir' => install_dir, 'service_binary' => node['wt_datadeleter']['datadeleter_binary']})
  code <<-EOH
        $binary_path = $env:install_dir + "\\" + $env:service_binary
  $binary_path_exists = Test-Path $binary_path
  if ($binary_path_exists) {
    &$binary_path --uninstall
  }
  EOH
end

powershell "uninstall deletion scheduler" do
  environment({'install_dir' => install_dir, 'service_binary' => node['wt_datadeleter']['deletionscheduler_binary']})
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
