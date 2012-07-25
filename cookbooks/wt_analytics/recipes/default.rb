#
# Cookbook Name:: wt_analytics
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# require 'rest_client'
# require 'rexml/document'
# require 'json'

if deploy_mode?
	include_recipe "wt_analytics::uninstall"
	include_recipe "ms_dotnet4::regiis"
end

# properties
install_dir    = File.join(node['wt_common']['install_dir_windows'], node['wt_analytics']['install_dir']).gsub(/[\\\/]+/,"\\")
install_url    = node['wt_analytics']['download_url']

user_data = data_bag_item('authorization', node.chef_environment)
ui_user   = user_data['wt_common']['ui_user']
ui_pass   = user_data['wt_common']['ui_pass']

app_pool_name = node['wt_analytics']['app_pool_name']

directory install_dir do
	action :create
	recursive true
end

iis_site 'Default Web Site' do
	action [:stop, :delete]
end

iis_pool app_pool_name do
	pipeline_mode :Integrated
	runtime_version "4.0"
	private_mem node['wt_analytics']['app_pool_private_memory']
	pool_username ui_user
	pool_password ui_pass
	action [:add, :config]
end

iis_site 'Analytics' do
	protocol :http
	port node['wt_analytics']['website_port']
	path install_dir
	app_pool app_pool_name
	action [:add, :start]
end

wt_base_icacls install_dir do
	user ui_user
	perm :modify
	action :grant
end

wt_base_icacls install_dir do
	user "IUSR"
	perm :read
	action :grant
end

# resolves "Unable to obtain public key for StrongNameKeyPair" error
wt_base_icacls "C:\\ProgramData\\Microsoft\\Crypto\\RSA\\MachineKeys" do
	user ui_user
	perm :modify
	action :grant
end

wt_base_netlocalgroup "Performance Monitor Users" do
	user ui_user
	returns [0, 2]
	action :add
end

if deploy_mode?

	windows_zipfile install_dir do
		source install_url
		action :unzip
	end

	template "#{install_dir}\\Web.config" do
		source "webConfig.erb"
		 variables(
			# master database host
			:master_host => node['wt_common']['master_host'],

			# cache config
			:cache_enabled => node['wt_analytics']['cache_enabled'],
			:cache_hosts   => node['wt_common']['cache_hosts'],
			:cache_region  => node['wt_analytics']['cache_region'],

			# hbase config
			:hbase_location    => node['hbase']['location'],
			:hbase_thrift_port => node['hbase']['thrift_port'],
			:hbase_dc_id       => node['hbase']['data_center_id'],
			:hbase_pod_id      => node['hbase']['pod_id'],

			# cassandra config
			:cass_host            => node['wt_common']['cassandra_host'],
			:cass_report_column   => node['wt_common']['cassandra_report_column'],
			:cass_metadata_column => node['wt_common']['cassandra_meta_column'],
			:cass_thrift_port     => node['wt_common']['cassandra_thrift_port'],

			# app setting section
			:rest_base_uri           => node['wt_analytics']['rest_base_uri'],
			:ondemand_base_domain    => node['wt_analytics']['ondemand_base_domain'],
			:fb_app_clientid         => node['wt_analytics']['fb_app_clientid'],
			:fb_app_clientsecret     => node['wt_analytics']['fb_app_clientsecret'],
			:beta                    => node['wt_analytics']['beta'],
			:branding                => node['wt_analytics']['branding'],
			:tagbuilder_download_url => node['wt_analytics']['tagbuilder_download_url'],
			:tagbuilder_url_template => node['wt_analytics']['tagbuilder_url_template'],
			:help_link               => node['wt_analytics']['help_link'],
			:hmap_url                => node['wt_analytics']['hmap_url'],
			:reinvigorate_code       => node['wt_analytics']['reinvigorate_tracking_code'],
			:show_profiling          => node['wt_analytics']['show_profiling'],

			# proxy
			:proxy_enabled => node['wt_analytics']['proxy_enabled'],
			:proxy_address => node['wt_analytics']['proxy_address'],

			# other settings
			:custom_errors        => node['wt_analytics']['custom_errors'],
			:search_host          => node['wt_common']['search_hostname'],
			:monitor_service_addr => node['wt_common']['monitor_service_addr']
		)
	end

	template "#{install_dir}\\App_Data\\brands\\mapping.xml" do
		source "mapping.xml.erb"
		variables(
			:bba_domain => node['wt_analytics']['bba_domain']
		)
	end

	template "#{install_dir}\\App_Data\\brands\\webtrends\\brand.xml" do
		source "webtrends-brand.xml.erb"
		variables(
			:help_link            => node['wt_analytics']['help_link'],
			:ondemand_base_domain => node['wt_analytics']['ondemand_base_domain']
		)
	end

end
