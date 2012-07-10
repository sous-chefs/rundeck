#
# Cookbook Name:: wt_analytics
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
require 'rest_client'
require 'rexml/document'
require 'json'

if deploy_mode? 
  include_recipe "wt_analytics::uninstall" 
  include_recipe "ms_dotnet4::resetiis" 
end


#Properties
install_dir = node['wt_common']['install_dir_windows'] + node['wt_analytics']['install_dir']
install_url = node['wt_analytics']['download_url']
install_logdir = node['wt_common']['install_log_dir_windows']
pod = node.chef_environment
user_data = data_bag_item('authorization', pod)
ui_user = user_data['wt_common']['ui_user']
ui_password = user_data['wt_common']['ui_pass']
app_pool = node['wt_analytics']['app_pool']
auth_cmd = "/section:applicationPools /[name='#{app_pool}'].processModel.identityType:SpecificUser /[name='#{app_pool}'].processModel.userName:#{ui_user} /[name='#{app_pool}'].processModel.password:#{ui_password}"

directory install_dir do
	action :create
	recursive true
end

directory install_logdir do
	action :create
	recursive true
end

iis_site 'Default Web Site' do
	action [:stop, :delete]
end

iis_site 'Analytics' do
	protocol :http
    port 80
    path "#{node['wt_common']['install_dir_windows']}\\Insight"
	action [:add,:start]
end

wt_base_icacls install_dir do
	action :grant
	user user_data['wt_common']['ui_user']
	perm :read
end

if deploy_mode?
	windows_zipfile install_dir do
		source install_url
		action :unzip
	end
	
	iis_pool app_pool do
  	  pipeline_mode :Integrated
  	  runtime_version "4.0"
      action [:add, :config]
    end
	
	search_server = search(:node, "chef_environment:#{node.chef_environment} AND role:wt_search")
	search_host = "#{search_server[0][:fqdn]}"
	
	template "#{install_dir}\\web.config" do
	  source "webConfig.erb"
	   variables(		
		  :master_host => node['wt_common']['master_host'],
		  :cass_host => node['wt_common']['cassandra_host'],
		  :report_column => node['wt_common']['cassandra_report_column'],
		  :thrift_port => node['wt_common']['cassandra_thrift_port'],
		  :metadata_column => node['wt_common']['cassandra_meta_column'],
		  :cache_hosts => search(:node, "chef_environment:#{node.chef_environment} AND role:memcached"),
		  :search_host => search_host,
		  :cache_region => node['wt_common']['cache_region']
	  )
	end
	
	iis_config auth_cmd do
  	action :config
  end
end