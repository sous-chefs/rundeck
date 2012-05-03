#
# Cookbook Name:: roadrunner
# Recipe:: default
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the needed components to full setup/configure the RoadRunner service


log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] == "true" then 
include_recipe "wt_roadrunner::uninstall" 
end
# source build
build_url = "#{node['wt_roadrunner']['build_url']}#{node['wt_roadrunner']['zip_file']}"

# get parameters
master_host = node['wt_common']['master_host']

# destinations
install_dir = "#{node['wt_common']['install_dir_windows']}#{node['wt_roadrunner']['install_dir']}"
log_dir     = "#{node['wt_common']['install_dir_windows']}#{node['wt_roadrunner']['log_dir']}"

# get data bag items 
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['loader_user']
svcpass = auth_data['wt_common']['loader_pass']

$rr_port = 8097
gac_cmd = "#{install_dir}\\gacutil.exe /i \"#{install_dir}\\Webtrends.RoadRunner.SSISPackageRunner.dll\""
urlacl_cmd = "netsh http add urlacl url=http://+:#{$rr_port}/ user=\"#{svcuser}\""
firewall_cmd="netsh advfirewall firewall add rule name=\"Webtrends RoadRunner port #{$rr_port}\" dir=in action=allow protocol=TCP localport=#{$rr_port}"
share_cmd="net share wrs=#{install_dir} /grant:EVERYONE,FULL /remark:\"Set from the chef run\""

# determine root drive of install_dir - ENG390500
if (install_dir =~ /^(\w:)\\.*$/)
	install_dir_drive = $1
else
	raise Chef::Exceptions::AttributeNotFound,
		"could not determine install_dir_drive, please verify value of install_dir: #{install_dir}"
end

# create the install directory
directory "#{install_dir}" do
	recursive true
	action :create
end

# set permissions for the service user to have read access to the install drive
wt_base_icacls "#{install_dir_drive}" do
	action :grant
	user svcuser 
	perm :read
end

# set permissions for the log readers group to have read access to the install directory
wt_base_icacls "#{install_dir}" do
	action :grant
	user node['wt_common']['wrsread_group'] 
	perm :read
end

# create the log directory
directory "#{log_dir}" do
	recursive true
	action :create
end

# allow the service account to modify files in the log directory
wt_base_icacls "#{log_dir}" do
	action :grant
	user svcuser 
	perm :modify
end

if ENV["deploy_build"] == "true" then 
	ENV["deploy_build"] = "false"
  log("Source URL: #{build_url}") { level :info}
  # unzip the install package
  windows_zipfile "#{install_dir}" do
  	source "#{build_url}"
  	action :unzip	
  end

  template "#{install_dir}\\Webtrends.RoadRunner.Service.exe.config" do
	  source "RRServiceConfig.erb"
	  variables(		
		  :master_host => master_host
	  )
  end

  template "#{install_dir}\\log4net.config" do
	  source "log4net.erb"
	  variables(		
	  	:logdir => log_dir
	  )
  end

  execute "gac" do
	  command gac_cmd
	  cwd install_dir	
  end

 powershell "create service" do
   environment({'serviceName' => node['wt_roadrunner']['service_name'], 'install_dir' => install_dir, 'user' => svcuser, 'pass' => svcpass})	
   code <<-EOH
 		$computer = gc env:computername
 		$class = "Win32_Service"
  	$method = "Create"
		$mc = [wmiclass]"\\\\$computer\\ROOT\\CIMV2:$class"
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

  # share the install directory
  execute "share_install_dir" do
  	command share_cmd
  	cwd install_dir_drive
  	ignore_failure true
  end
end

service "wt_roadrunner" do
	action :start
	ignore_failure true
end