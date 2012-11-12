#
# Cookbook Name:: wt_streaming_viz
# Recipe:: default
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the Streaming Viz IIS app

if ENV["deploy_build"] == "true" then
  include_recipe "ms_dotnet4::regiis"
  include_recipe "wt_streaming_viz::uninstall"
else
    log "The deploy_build value is not set or is false so we will only update the configuration"
end

#Properties
install_dir = "#{node['wt_common']['install_dir_windows']}\\Webtrends.Streaming.Viz"
install_logdir = node['wt_common']['install_log_dir_windows']
log_dir = "#{node['wt_common']['install_dir_windows']}\\logs"
app_pool = node['wt_streaming_viz']['app_pool']
user_data = data_bag_item('authorization', node.chef_environment)
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
	path install_dir
	action [:add,:start]
	application_pool app_pool
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

# Allow anonymous access to scripts, etc
wt_base_icacls install_dir do
	action :grant
	user "IUSR"
	perm :read
end

wt_base_icacls log_dir do
	action :grant
	user user_data['wt_common']['ui_user']
	perm :modify
end

if ENV["deploy_build"] == "true" then
  windows_zipfile install_dir do
		source node['wt_streaming_viz']['download_url']
		action :unzip
  end
  iis_config auth_cmd do
  	action :config
  end
end

auth_base = node['wt_sauth']['auth_service_url']
auth_version = node['wt_streaming_viz']['auth_service_version']
template "#{install_dir}\\appSettings.config" do
	source "appSettings.config.erb"
	variables(
		:auth_url => "#{auth_base}/#{auth_version}",
		:auth_url_base => node['wt_streaming_viz']['auth_service_url_base'],
		:cam_url => node['wt_cam']['cam_service_url'],
		:cam_url_base => node['wt_streaming_viz']['cam_service_url_base'],
		:sapi_url   => node['wt_streamingapi']['sapi_service_url'],
		:help_url => "http://help.webtrends.com",
		:account_url => node['wt_portfolio_admin']['account_ui_url'],
		:streams_url => node['wt_streaming_viz']['streams_ui_url'],
		:stream_client_id => user_data['wt_streaming_viz']['client_id'],
		:stream_client_secret => user_data['wt_streaming_viz']['client_secret']
	)
end

template "#{install_dir}\\web.config" do
	source "web.config.erb"
	variables(
		:elmah_remote_access => node['wt_streaming_viz']['elmah_remote_access'],
		:custom_errors => node['wt_streaming_viz']['custom_errors'],
		# proxy
		:proxy_enabled => node['wt_streaming_viz']['proxy_enabled'],
		:proxy_address => node['wt_common']['http_proxy_url'],
		# forms auth
		:machine_validation_key => user_data['wt_iis']['machine_validation_key'],
		:machine_decryption_key => user_data['wt_iis']['machine_decryption_key']
	)
end

template "#{install_dir}\\log4net.config" do
	source "log4net.config.erb"
	variables(
		:log_level => node['wt_streaming_viz']['log_level'],
		:log_dir => log_dir
	)
end

share_wrs