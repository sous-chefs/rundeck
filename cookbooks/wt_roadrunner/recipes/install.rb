#
# Cookbook Name:: roadrunner
# Recipe:: default
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe installs the needed components to full setup/configure the RoadRunner service

include_recipe "windows"

# source build
build_url = "#{node['wt_roadrunner']['build_url']}#{node['wt_roadrunner']['zip_file']}"

# destinations
install_dir = "#{node['wt_common']['install_dir_windows']}\\RoadRunner"
log_dir     = "#{node['wt_common']['install_dir_windows']}\\logs"

# get data bag items 
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['loader_user']
svcpass = auth_data['wt_common']['loader_pass']

# get parameters
master_host = node['wt_common']['master_host']

rr_port = 8097
gac_cmd = "#{install_dir}\\gacutil.exe /i \"#{install_dir}\\Webtrends.RoadRunner.SSISPackageRunner.dll\""
urlacl_cmd = "netsh http add urlacl url=http://+:#{rr_port}/ user=\"#{svcuser}\""
firewall_cmd="netsh advfirewall firewall add rule name=\"Webtrends RoadRunner port #{rr_port}\" dir=in action=allow protocol=TCP localport=#{rr_port}"
share_cmd="net share wrs=#{install_dir} /grant:EVERYONE,FULL /remark:\"Set from the chef run\""

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

# ruby code block to create the Windows service
ruby_block "create_service" do
  block do      
      require "win32/service"
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
end