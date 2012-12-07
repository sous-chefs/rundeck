#
# Cookbook Name:: wt_search
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
  include_recipe "wt_search::uninstall"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

# get parameters
download_url = node['wt_search']['download_url']
master_host = node['wt_masterdb']['host']

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_search']['install_dir']).gsub(/[\\\/]+/,"\\")
log_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_search']['log_dir']).gsub(/[\\\/]+/,"\\")

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

	template "#{install_dir}\\Webtrends.Search.Service.exe.config" do
	  source "searchConfig.erb"
	  variables(
		  :master_host => master_host,
		  :cass_host => node['cassandra']['cassandra_host'],
		  :cass_thrift_port => node['cassandra']['cassandra_thrift_port'],
		  :report_column => node['cassandra']['cassandra_report_column'],
		  :metadata_column => node['cassandra']['cassandra_meta_column']
	  )
	end

	template "#{install_dir}\\Webtrends.Search.Bulkload.exe.config" do
	  source "bulkloadConfig.erb"
	  variables(
		  :master_host => master_host,
		  :cass_host => node['cassandra']['cassandra_host'],
		  :report_column => node['cassandra']['cassandra_report_column'],
		  :thrift_port => node['cassandra']['cassandra_thrift_port'],
		  :metadata_column => node['cassandra']['cassandra_meta_column']
	  )
	end

	template "#{install_dir}\\LocalStateRetriever.exe.config" do
	  source "localStateRetrieverConfig.erb"
	  variables(
		  :master_host => master_host,
		  :cass_host => node['cassandra']['cassandra_host'],
		  :report_column => node['cassandra']['cassandra_report_column'],
		  :metadata_column => node['cassandra']['cassandra_meta_column']
	  )
	end

	powershell "create service" do
		environment({'serviceName' => node['wt_search']['service_name'], 'serviceBinary' => node['wt_search']['service_binary'], 'install_dir' => install_dir, 'svcuser' => svcuser, 'svcpass' => svcpass})
		code <<-EOH
 		# $computer = gc env:computername
 		$class = "Win32_Service"
		$method = "Create"
		# $mc = [wmiclass]"\\\\$computer\\ROOT\\CIMV2:$class"
		$mc = [wmiclass]"\\\\.\\ROOT\\CIMV2:$class"
		$servicePath = $env:install_dir + "\\$env:serviceBinary"
		$inparams = $mc.PSBase.GetMethodParameters($method)
		$inparams.DesktopInteract = $false
		$inparams.DisplayName = $env:serviceName
		$inparams.ErrorControl = 0
		$inparams.LoadOrderGroup = $null
		$inparams.LoadOrderGroupDependencies = $null
		$inparams.Name = $env:serviceName
		$inparams.PathName = $servicePath
		$inparams.ServiceDependencies = $null
		$inparams.ServiceType = 16
		$inparams.StartMode = "Automatic"
		$inparams.StartName = $env:svcuser
		$inparams.StartPassword = $env:svcpass

		$result = $mc.PSBase.InvokeMethod($method,$inparams,$null)
		$result | Format-List
		EOH
	end
	share_wrs
end

service node['wt_search']['service_name'] do
	action :start
	ignore_failure true
end
