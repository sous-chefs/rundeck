#
# Cookbook Name:: wt_cam
# Recipe:: default
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the CAM IIS app

if deploy_mode?
  include_recipe "ms_dotnet4::resetiis"
  include_recipe "wt_cam::uninstall" 
end


#Properties
install_dir = "#{node['wt_common']['install_dir_windows']}\\CAM"
install_logdir = node['wt_common']['install_log_dir_windows']
app_pool = node['wt_cam']['app_pool']
pod = node.chef_environment
user_data = data_bag_item('authorization', pod)
auth_cmd = "/section:applicationPools /[name='#{app_pool}'].processModel.identityType:SpecificUser /[name='#{app_pool}'].processModel.userName:#{user_data['wt_common']['ui_user']} /[name='#{app_pool}'].processModel.password:#{user_data['wt_common']['ui_pass']}"

iis_site 'Default Web Site' do
	action [:stop, :delete]
end

directory install_dir do
	recursive true
	action :create
end

# empty out default folder
execute "rmdir_wwwroot" do
	command "for /d %i in (c:\\inetpub\\wwwroot\\*) do rmdir /s /q %i"
	action :nothing
end
execute "del_wwwroot" do
	command "del /q c:\\inetpub\\wwwroot\\*"
	action :nothing
end

iis_site 'CAM' do
    protocol :http
    port 80
    path "c:\\inetpub\\wwwroot"
	action [:add,:start]
	notifies :run, resources(:execute => "del_wwwroot") 
	notifies :run, resources(:execute => "rmdir_wwwroot") 
end

wt_base_icacls install_dir do
	action :grant
	user user_data['wt_common']['ui_user']
	perm :modify
end

if deploy_mode?
  windows_zipfile install_dir do
    source node['wt_cam']['download_url']
    action :unzip	
  end
  
  template "#{install_dir}\\Webtrends.CamWeb.UI\\web.config" do
  	source "webConfig.erb"  
	variables(
		:db_server => node['wt_cam']['db_server'],
		:db_name   => node['wt_cam']['db_name']
  	)	
  end
  
  iis_pool app_pool do
	pipeline_mode :Integrated
  	runtime_version "4.0"
	action [:add, :config]
  end
  
  iis_app "CAM" do
  	path "/CamService"
  	application_pool app_pool
  	physical_path "#{install_dir}\\Webtrends.CamWeb.UI"
  	action :add
  end
	
  iis_config auth_cmd do
  	action :config
  end
end
