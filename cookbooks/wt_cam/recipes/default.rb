#
# Cookbook Name:: wt_cam
# Recipe:: pre
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe sets up the base configuration for DX

log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] == "true" then 
  include_recipe "wt_cam::uninstall" 
end


#Properties
install_dir = "#{node['wt_common']['install_dir_windows']}\\CAM"
install_logdir = node['wt_common']['install_log_dir_windows']
app_pool = node['wt_cam']['app_pool']
install_url = "#{node['wt_cam']['url']}#{node['wt_cam']['zip_file']}"
db_server = node['wt_cam']['database']
pod = node.chef_environment
user_data = data_bag_item('authorization', pod)
user = user_data['wt_common']['camdb_user']
password = user_data['wt_common']['camdb_pass']

pod = node.chef_environment

iis_site 'Default Web Site' do
	action [:stop, :delete]
end

directory install_dir do
	recursive true
	action :create
end

iis_site 'CAM' do
    protocol :http
    port 80
    path install_dir
	action [:add,:start]
end

if ENV["deploy_build"] == "true" then 
  execute "aspnet_regiis" do
    command "%WINDIR%\\Microsoft.Net\\Framework64\\v4.0.30319\\aspnet_regiis -i -enable"
    action :run
  end

  windows_zipfile install_dir do
    source install_url
    action :unzip	
  end
  
  template "#{install_dir}\\Webtrends.CamWeb.UI\\web.config" do
  	source "webConfig.erb"  
	variables(
  		:db_server => node['wt_cam']['db_server'],
  		:user_id => user_data['wt_common']['camdb_user'],
  		:password => user_data['wt_common']['camdb_pass']
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
end