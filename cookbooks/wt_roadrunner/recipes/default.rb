#
# Cookbook Name:: wt_roadrunner
# Recipe:: default
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends, Inc.
#
# All rights reserved - Do Not Redistribute
#
# This recipe installs the needed components to full setup/configure the RoadRunner service
#

log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploy first"
  include_recipe "wt_roadrunner::uninstall"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

# source build
tarball      = node['wt_roadrunner']['download_url'].split("/")[-1]
download_url = node['wt_roadrunner']['download_url']

# get parameters
master_host = node['wt_masterdb']['master_host']

# destinations
install_dir = "#{node['wt_common']['install_dir_windows']}#{node['wt_roadrunner']['install_dir']}"
log_dir     = "#{node['wt_common']['install_dir_windows']}#{node['wt_roadrunner']['log_dir']}"

# get data bag items
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['loader_user']
svcpass = auth_data['wt_common']['loader_pass']

rr_port = 8097
gac_cmd = "#{install_dir}\\gacutil.exe /i \"#{install_dir}\\Webtrends.RoadRunner.SSISPackageRunner.dll\""
urlacl_cmd = "netsh http add urlacl url=http://+:#{rr_port}/ user=\"#{svcuser}\""
firewall_cmd="netsh advfirewall firewall add rule name=\"Webtrends RoadRunner port #{rr_port}\" dir=in action=allow protocol=TCP localport=#{$rr_port}"

# determine root drive of install_dir - ENG390500
if (install_dir =~ /^(\w:)\\.*$/)
	install_dir_drive = $1
else
	raise Chef::Exceptions::AttributeNotFound,
		"could not determine install_dir_drive, please verify value of install_dir: #{install_dir}"
end

# create the install directory
directory install_dir do
	recursive true
	action :create
end

# set permissions for the service user to have read access to the install drive - ENG390500
wt_base_icacls install_dir_drive do
	action :grant
	user svcuser
	perm :read
end

# create the log directory
directory log_dir do
	recursive true
	action :create
end

# allow the service account to modify files in the log directory
wt_base_icacls log_dir do
	action :grant
	user svcuser
	perm :modify
end

if ENV["deploy_build"] == "true" then

	# unzip the install package
	windows_zipfile install_dir do
		source "#{Chef::Config[:file_cache_path]}/#{tarball}"
		action :unzip
	end

	template "#{install_dir}\\Webtrends.RoadRunner.Service.exe.config" do
	  source "Webtrends.RoadRunner.Service.exe.config.erb"
	  variables(
		  :master_host => master_host
	  )
	end

	template "#{install_dir}\\log4net.config" do
	  source "log4net.config.erb"
	  variables(
	  	:logdir => log_dir
	  )
	end

	execute "gac" do
	  command gac_cmd
	  cwd install_dir
	end

	powershell "create service" do
		environment({'serviceName' => node['wt_roadrunner']['service_name'], 'install_dir' => install_dir, 'svcuser' => svcuser, 'svcpass' => svcpass})
		code <<-EOH
 		# $computer = gc env:computername
 		$class = "Win32_Service"
		$method = "Create"
		# $mc = [wmiclass]"\\\\$computer\\ROOT\\CIMV2:$class"
		$mc = [wmiclass]"\\\\.\\ROOT\\CIMV2:$class"
		$servicePath = $env:install_dir + "\\Webtrends.RoadRunner.Service.exe"
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

	#Set the ACL up to allow http traffic on port 8097
	execute "netsh_urlacl" do
		command urlacl_cmd
		cwd install_dir
	end

	# Set the firewall to allow traffic into the system on port 8097
	execute "netsh_firewall" do
		command firewall_cmd
		cwd install_dir
	end

	share_wrs
end

service node['wt_roadrunner']['service_name'] do
	action :start
	ignore_failure true
end