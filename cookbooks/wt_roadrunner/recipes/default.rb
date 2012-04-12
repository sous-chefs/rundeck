#
# Cookbook Name:: roadrunner
# Recipe:: default
# Author:: Kendrick Martin
#
# Copyright 2011, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the needed components to full setup/configure the RoadRunner service

include_recipe "windows"
require "win32/service"
include Win32

# source build
build_url = "#{node['wt_common']['install_server']}#{node['wt_roadrunner']['url']}#{node['wt_roadrunner']['zip_file']}"

# destinations
install_dir = "#{node['wt_common']['install_dir_windows']}\\RoadRunner"
log_dir     = "#{node['wt_common']['install_dir_windows']}\\logs"

# get data bag items 
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['loader_user']
svcpass = auth_data['wt_common']['loader_pass']

# get parameters
master_host = node['wt_common']['master_host']

# determine root drive of install_dir - ENG390500
if (install_dir =~ /^(\w:)\\.*$/)
	install_dir_drive = $1
else
	raise Chef::Exceptions::AttributeNotFound,
		"could not determine install_dir_drive, please verify value of install_dir: #{install_dir}"
end

Chef::Log.info "Source URL: #{build_url}"

gac_cmd = "#{install_dir}\\gacutil.exe /i \"#{install_dir}\\Webtrends.RoadRunner.SSISPackageRunner.dll\""
urlacl_cmd = "netsh http add urlacl url=http://+:8097/ user=\"#{svcuser}\""
firewall_cmd="netsh advfirewall firewall add rule name=\"Webtrends RoadRunner port 8097\" dir=in action=allow protocol=TCP localport=8097"
share_cmd="net share wrs=#{install_dir} /grant:EVERYONE,FULL /remark:\"Set from the install batch file\""

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

# share the install directory
execute "share_install_dir" do
	command share_cmd
	cwd install_dir_drive
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

# unzip the file unless the applications is already installed
windows_zipfile "#{install_dir}" do
	source "#{build_url}"
	action :unzip	
	not_if {::File.exists?("#{install_dir}\\Webtrends.RoadRunner.Service.exe")}
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
	not_if { node[:rr_configured]}
end

# ruby code block to create the Windows service
ruby_block "create_service" do
  block do
    if !Service.exists?(wt_roadrunner)
	  # create the service since it doesn't exist
      Service.create('wt_roadrunner', nil, Service::WIN32_OWN_PROCESS,
	'Webtrends Roadrunner service for GPU acceleration of VDM SQL queries',
        Service::AUTO_START, Service::ERROR_NORMAL, '#{install_dir}\\Webtrends.RoadRunner.Service.exe',
        '#{svcuser}', '#{svcpass}', 'Webtrends Roadrunner'
      )
	  end
  end
  action :create
end

#Set the ACL up to allow http traffic on port 8097
execute "netsh_urlacl" do
	command urlacl_cmd
	cwd install_dir
	not_if { node[:rr_configured]}
end

# Set the firewall to allow traffic into the system on port 8097
execute "netsh_firewall" do
	command firewall_cmd
	cwd install_dir
	not_if { node[:rr_configured]}
end

service "wt_roadrunner" do
	action :start
end