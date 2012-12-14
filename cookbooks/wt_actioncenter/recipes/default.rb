#
# Cookbook Name:: wt_actioncenter
# Recipe:: default
# Author: Marcus Vincent(<marcus.vincent@webtrends.com>)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the ActionCenter WebAPI IIS app
 
if ENV["deploy_build"] == "true" then
 include_recipe "ms_dotnet4::regiis"
 include_recipe "wt_actioncenter::uninstall"
end
 
#Properties
install_dir = "#{node['wt_common']['install_dir_windows']}\\Webtrends.ActionCenter"
install_logdir = node['wt_common']['install_log_dir_windows']
log_dir = "#{node['wt_common']['install_dir_windows']}\\logs"
app_pool = node['wt_actioncenter']['app_pool']
user_data = data_bag_item('authorization', node.chef_environment)
auth_cmd = "/section:applicationPools /[name='#{app_pool}'].processModel.identityType:SpecificUser /[name='#{app_pool}'].processModel.userName:#{user_data['wt_common']['ui_user']} /[name='#{app_pool}'].processModel.password:#{user_data['wt_common']['ui_pass']}"
http_port = node['wt_actioncenter']['port']
 
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
 
iis_site 'ActionCenter' do
 protocol :http
 port http_port
 application_pool app_pool
 path install_dir
 action [:add,:start]
 retries 2
end

if ENV["deploy_build"] == "true" then
 windows_zipfile install_dir do
   source node['wt_actioncenter']['download_url']
   action :unzip
 end
end
 
template "#{install_dir}\\web.config" do
 source "web.config.erb"
 variables(    
     # master database host
     :master_host => node['wt_masterdb']['host'],
     
# cache config
     :cache_enabled => node['wt_actioncenter']['cache_enabled'],
     :cache_hosts   => node['memcached']['cache_hosts'],
     :cache_region  => node['wt_actioncenter']['cache_region'],

     # cassandra config
     :cass_host            => node['cassandra']['cassandra_host'],
     :cass_report_column   => node['cassandra']['cassandra_report_column'],
     :cass_metadata_column => node['cassandra']['cassandra_meta_column'],
     :cass_thrift_port     => node['cassandra']['cassandra_thrift_port'],
 )
end
 
template "#{install_dir}\\log4net.config" do
 source "log4net.config.erb"
 variables(
   :log_level => node['wt_actioncenter']['log_level']
 )
end

iis_config auth_cmd do
 action :config
end
 
share_wrs
