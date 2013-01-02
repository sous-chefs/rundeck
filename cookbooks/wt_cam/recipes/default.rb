#
# Cookbook Name:: wt_cam
# Recipe:: default
# Author: Kendrick Martin(<kendrick.martin@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the CAM IIS app

if ENV["deploy_build"] == "true" then
  include_recipe "ms_dotnet4::regiis"
  include_recipe "wt_cam::uninstall"
end

#Properties
install_dir = "#{node['wt_common']['install_dir_windows']}\\Webtrends.Cam"
install_logdir = node['wt_common']['install_log_dir_windows']
log_dir = "#{node['wt_common']['install_dir_windows']}\\logs"
app_pool = node['wt_cam']['app_pool']
user_data = data_bag_item('authorization', node.chef_environment)
auth_cmd = "/section:applicationPools /[name='#{app_pool}'].processModel.identityType:SpecificUser /[name='#{app_pool}'].processModel.userName:#{user_data['wt_common']['ui_user']} /[name='#{app_pool}'].processModel.password:#{user_data['wt_common']['ui_pass']}"
http_port = node['wt_cam']['port']

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
  rights :write, user_data['wt_common']['ui_user']
end

directory log_dir do
  recursive true
  action :create
  rights :write, user_data['wt_common']['ui_user']
end

iis_site 'CAM' do
  protocol :http
  port http_port
  application_pool app_pool
  path install_dir
  action [:add,:start]
  retries 2
end

wt_base_firewall 'CAMWS' do
  protocol "TCP"
  port http_port
  action :open_port
end

wt_base_netlocalgroup "Performance Monitor Users" do
  user user_data['wt_common']['ui_user']
  returns [0, 2]
  action :add
end

if ENV["deploy_build"] == "true" then
  windows_zipfile install_dir do
    source node['wt_cam']['cam']['download_url']
    action :unzip
  end
end

template "#{install_dir}\\web.config" do
  source "web.config.erb"
  variables(
    :db_server => node['wt_cam']['db_server'],
    :db_name   => node['wt_cam']['db_name'],
    :ldap_host => node['wt_common']['ldap_host'],
    :ldap_port => node['wt_common']['ldap_port'],
    :ldap_user => user_data['wt_common']['ldap_user'],
    :ldap_password => user_data['wt_common']['ldap_password'],
    :smtp_host => node['wt_common']['smtp_server'],
    :streams_ui_url => node['wt_streaming_viz']['streams_ui_url']
    :sms_url => node['wt_streamingmanagementservice']['sms_service_url']
  )
end

template "#{install_dir}\\log4net.config" do
  source "log4net.config.erb"
  variables(
    :log_level => node['wt_cam']['log_level']
  )
end

# add the plugins here
include_recipe "wt_cam::cam_plugins"

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
