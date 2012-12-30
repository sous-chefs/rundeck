#
# Cookbook Name:: wt_sauth
# Recipe:: cam_auth
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the Auth IIS app component of CAM

if ENV["deploy_build"] == "true" then
  include_recipe "ms_dotnet4::regiis"
  include_recipe "wt_sauth::uninstall"
end

#Properties
install_dir = "#{node['wt_common']['install_dir_windows']}\\Webtrends.Auth"
install_logdir = node['wt_common']['install_log_dir_windows']
log_dir = "#{node['wt_common']['install_dir_windows']}\\logs"
app_pool = node['wt_sauth']['app_pool']
user_data = data_bag_item('authorization', node.chef_environment)
auth_cmd = "/section:applicationPools /[name='#{app_pool}'].processModel.identityType:SpecificUser /[name='#{app_pool}'].processModel.userName:#{user_data['wt_common']['ui_user']} /[name='#{app_pool}'].processModel.password:#{user_data['wt_common']['ui_pass']}"
http_port = node['wt_sauth']['port']

iis_pool app_pool do
	pipeline_mode :Integrated
	runtime_version "4.0"
	action [:add, :config]
end

iis_site 'Default Web Site' do
	action [:stop, :delete]
end

iis_pool 'DefaultAppPool' do
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

iis_site 'AUTH' do
	protocol :http
	port http_port
	application_pool app_pool
	path install_dir
	action [:add,:start]
	retries 2
end

wt_base_firewall 'AUTHWS' do
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

wt_base_netlocalgroup "Performance Monitor Users" do
        user user_data['wt_common']['ui_user']
        returns [0, 2]
        action :add
end

if ENV["deploy_build"] == "true" then
  windows_zipfile install_dir do
    source node['wt_sauth']['download_url']
    action :unzip
  end  

end

template "#{install_dir}\\web.config" do
	source "web.config.erb"
	variables(
		:db_server => node['wt_cam']['db_server'],
		:db_name   => node['wt_cam']['db_name'],
		:tokenExpirationMinutes => node['wt_sauth']['tokenExpirationMinutes'],
                :authCodeExpirationMinutes => node['wt_sauth']['authCodeExpirationMinutes'],
                :sessionExpirationMinutes => node['wt_sauth']['sessionExpirationMinutes'],
                :internal_domains => node['wt_sauth']['internal_domains'],
         	:machine_validation_key => user_data['wt_iis']['machine_validation_key'],
		:machine_decryption_key => user_data['wt_iis']['machine_decryption_key'],
		:ldap_host => node['wt_common']['ldap_host'],
		:ldap_port => node['wt_common']['ldap_port'],
		:ldap_user => user_data['wt_common']['ldap_user'],
		:ldap_password => user_data['wt_common']['ldap_password'],
		:smtp_host => node['wt_common']['smtp_server'],
		# Header bar UI locations
		:auth_url => node['wt_sauth']['auth_service_url'],
		#TODO Right env location
		:help_url => "http://help.webtrends.com",
		:account_url => node['wt_portfolio_admin']['account_ui_url'],
		:streams_url => node['wt_streaming_viz']['streams_ui_url']
	)
end

template "#{install_dir}\\log4net.config" do
	source "log4net.config.erb"
	variables(
		:log_level => node['wt_sauth']['log_level']
	)
end

iis_config auth_cmd do
	action :config
end


if ENV["deploy_build"] == "true" then

  #add the user to the admin group to create perfmon counters
  wt_base_netlocalgroup "Administrators" do
    user user_data['wt_common']['ui_user']
    returns [0, 2]
    action :add
  end  

	ruby_block "preheat app pool" do
    block do
      require 'net/http'
      uri = URI("http://localhost/")
      puts Net::HTTP.get(uri)
	  end
		action :create
  end
	
  #remove the user from the admin group
  wt_base_netlocalgroup "Administrators" do
    user user_data['wt_common']['ui_user']
    returns [0, 2]
    action :remove
  end

end

share_wrs
