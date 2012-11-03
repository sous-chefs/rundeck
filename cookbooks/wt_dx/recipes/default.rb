#
# Cookbook Name:: wt_dx
# Recipe:: default
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe sets up the base configuration for DX

if deploy_mode?
  include_recipe "wt_dx::uninstall"
  include_recipe "ms_dotnet4::regiis"
end

# Properties
install_dir = node['wt_common']['install_dir_windows']
install_dir_apps = "#{node['wt_common']['install_dir_windows']}\\Data Extraction API"
install_logdir = node['wt_common']['install_log_dir_windows']
user_data = data_bag_item('authorization', node.chef_environment)
app_pool_user = user_data['wt_common']['ui_user']
app_pool_password = user_data['wt_common']['ui_pass']

# Create the directories
directory install_dir_apps do
  action :create
  recursive true
end

%w{"v3" "v2_1"}.each do |dir|
  directory "#{install_dir_apps}\\#{dir}" do
    action :create
    recursive true
  end
end

# Create the DX site
iis_site 'DX' do
	protocol :http
    port node['wt_dx']['port']
    path install_dir_apps
	action [:add, :start]
end

wt_base_firewall 'DXWS' do
	protocol "TCP"
	port node['wt_dx']['port']
	action [:open_port]
end

if deploy_mode?

  # Create the app pools
  iis_pool node['wt_dx']['v2_1']['app_pool'] do
      thirty_two_bit :true
      action [:add, :config]
  end

  iis_pool node['wt_dx']['v3']['app_pool'] do
    pipeline_mode :Integrated
    runtime_version "4.0"
    action [:add, :config]
  end

  iis_pool node['wt_dx']['v3']['streamingservices']['app_pool'] do
    pipeline_mode :Integrated
    action [:add, :config]
  end

  # Create the apps
  iis_app "DX" do
  	path "/v2_1"
  	application_pool node['wt_dx']['v2_1']['app_pool']
  	physical_path "#{install_dir}\\v21"
  	action :add
  end

  iis_app "DX" do
  	path "/v3"
  	application_pool node['wt_dx']['v3']['app_pool']
  	physical_path "#{install_dir_apps}\\v3\\Web Services"
  	action :add
  end

  iis_app "DX" do
  	path "/StreamingServices_v3"
  	application_pool node['wt_dx']['v3']['streamingservices']['app_pool']
  	physical_path "#{install_dir_apps}\v3\\StreamingServices"
  	action :add
  end

end

#Post Install

wt_base_icacls install_dir do
	action :grant
	user user_data['wt_common']['ui_user']
	perm :read
end

execute "ServiceModelReg" do
	command "%WINDIR%\\Microsoft.Net\\Framework64\\v4.0.30319\\ServiceModelReg.exe -r"
	action :run
end
