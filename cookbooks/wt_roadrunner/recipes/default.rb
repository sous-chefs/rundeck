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

# source build
build_url = "#{node['wt_common']['install_server']}#{node['wt_roadrunner']['url']}#{node['wt_roadrunner']['zip_file']}"

# destinations
install_dir = "#{node['wt_common']['install_dir']}\\RoadRunner"
log_dir     = "#{node['wt_common']['install_dir']}\\logs"

# get data bag items 
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['loader_user']
svcpass = auth_data['wt_common']['loader_pass']

# get parameters
master_host = node['wt_common']['master_host']

Chef::Log.info "Source URL: #{build_url}"

gac_cmd = "#{install_dir}\\gacutil.exe /i \"#{install_dir}\\Webtrends.RoadRunner.SSISPackageRunner.dll\""
sc_cmd = "\"%WINDIR%\\System32\\sc.exe create WebtrendsRoadRunnerService binPath= #{install_dir}\\Webtrends.RoadRunner.Service.exe obj= #{svcuser} password= #{svcpass} start= auto\""
netsh_cmd = "netsh http add urlacl url=http://+:8097/ user=\"#{svcuser}\""

directory "#{install_dir}" do
	recursive true
	action :create
end

wt_base_icacls "#{install_dir}" do
	action :grant
	user svcuser 
	perm :read
end

directory "#{log_dir}" do
	recursive true
	action :create
end

wt_base_icacls "#{log_dir}" do
	action :grant
	user svcuser 
	perm :modify
end

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

execute "sc" do
	command sc_cmd
	cwd install_dir	
end

execute "netsh" do
	command netsh_cmd
	cwd install_dir
	not_if { node[:rr_configured]}
end

service "WebtrendsRoadRunnerService" do
	action :start
end
