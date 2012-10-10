#
# Cookbook Name:: wt_datadeleter
# Recipe:: default
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends, Inc
#
# All rights reserved - Do Not Redistribute
#
# This recipe installs the needed components to full setup/configure the Search service
#
if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploy first"  
  include_recipe "wt_datadeleter::uninstall"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

# get parameters
download_url = node['wt_datadeleter']['download_url']
master_host = node['wt_masterdb']['master_host']

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_datadeleter']['install_dir'].gsub(/[\\\/]+/,"\\"))
log_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_deleter']['log_dir'].gsub(/[\\\/]+/,"\\"))

# get data bag items 
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']
svcpass = auth_data['wt_common']['system_pass']

# create the install directory
directory install_dir do
	recursive true
	action :create
end

directory log_dir do
	recursive true
	action :create
end

wt_base_icacls node['wt_common']['install_dir_windows'] do
	action :grant
	user svcuser 
	perm :modify
end

wt_base_netlocalgroup "Performance Monitor Users" do
	user svcuser
	returns [0, 2]
	action :add
end

if ENV["deploy_build"] == "true" then

	# unzip the install package
	windows_zipfile install_dir do
		source download_url
		action :unzip	
	end
	
	template "#{install_dir}\\DataDeleter.exe.config" do
	  source "DataDeleter.erb"
	  variables(		
		  :master_host => master_host,
	          :hbase_location => node['hbase']['location'],
		  :hbase_dc_id => node['wt_analytics_ui']['fb_data_center_id'],
		  :hbase_pod_id => node['wt_common']['pod_id'],
		  :cass_host => node['cassandra']['cassandra_host'],
		  :cass_thrift_port => node['cassandra']['cassandra_thrift_port'],
		  :report_column => node['cassandra']['cassandra_report_column'],
		  :metadata_column => node['cassandra']['cassandra_meta_column']
	  )
	end

	powershell "install service" do
		environment({'install_dir' => install_dir, 'service_binary' => node['wt_datadeleter']['service_binary']})
		code <<-EOH
		[System.Diagnostics.Process]::Start($env.install_dir+$env.service_binary, "--install")
		EOH
	end
	share_wrs 
end
