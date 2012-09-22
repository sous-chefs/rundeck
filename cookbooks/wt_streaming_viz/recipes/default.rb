#
# Cookbook Name:: wt_streaming_viz
# Recipe:: default
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the Streaming Viz IIS app

if deploy_mode?
  include_recipe "ms_dotnet4::regiis"
  include_recipe "wt_streaming_viz::uninstall"
end

#Properties
install_dir = "#{node['wt_common']['install_dir_windows']}\\Webtrends.Streaming.Viz"
install_logdir = node['wt_common']['install_log_dir_windows']
log_dir = "#{node['wt_common']['install_dir_windows']}\\logs"
app_pool = node['wt_streaming_viz']['app_pool']
pod = node.chef_environment
user_data = data_bag_item('authorization', pod)
auth_cmd = "/section:applicationPools /[name='#{app_pool}'].processModel.identityType:SpecificUser /[name='#{app_pool}'].processModel.userName:#{user_data['wt_common']['ui_user']} /[name='#{app_pool}'].processModel.password:#{user_data['wt_common']['ui_pass']}"
http_port = node['wt_streaming_viz']['port']

iis_pool app_pool do
    pipeline_mode :Integrated
    runtime_version "4.0"
    action [:add, :config]
end

iis_site 'Default Web Site' do
	action [:stop, :delete]
end

directory install_dir do
	recursive true
	action :create
end

directory log_dir do
	recursive true
	action :create
end

iis_site 'StreamingViz' do
    protocol :http
    port http_port
    path "#{install_dir}"
	action [:add,:start]
	retries 2
end

wt_base_firewall 'StreamingViz' do
    protocol "TCP"
    port http_port
    action [:open_port]
end

wt_base_icacls install_dir do
	action :grant
	user user_data['wt_common']['ui_user']
	perm :modify
end

wt_base_icacls log_dir do
	action :grant
	user user_data['wt_common']['ui_user']
	perm :modify
end

if deploy_mode?
  windows_zipfile install_dir do
    source node['wt_streaming_viz']['download_url']
    action :unzip
  end

  template "#{install_dir}\\appSettings.config" do
  	source "appSettings.config.erb"
	variables(
		:cam_auth_url => node['wt_streaming_viz']['cam_auth_url'],
		:sapi_url   => node['wt_streaming_viz']['sapi_url'],
        :chef_environment => pod
  	)
  end

  # template "#{install_dir}\\log4net.config" do
  #       source "cam.log4net.config.erb"
  #       variables(
  #               :log_level => node['wt_streaming_viz']['cam']['log_level']
  #       )
  # end

  iis_app "StreamingViz" do
  	path "/"
  	application_pool app_pool
  	physical_path "#{install_dir}"
  	action :add
  end

  iis_config auth_cmd do
  	action :config
  end

end
