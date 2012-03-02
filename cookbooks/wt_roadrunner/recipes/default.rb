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

installdir = "#{node['wt_common']['install_dir']}\\RoadRunner"
zip_file = node['wt_roadrunner']['zip_file']
install_url = node['wt_common']['install_server']
build_url = node['wt_roadrunner']['url']

pod = node.chef_environment
user_data = data_bag_item('authorization', pod)
master_host = node['wt_common']['master_host']
user = user_data['wt_common']['loader_user']
password = user_data['wt_common']['loader_pass']

rr_url = "#{install_url}#{build_url}#{zip_file}"

Chef::Log.info "RR URL: #{rr_url}"
Chef::Log.info "RR DIR: #{installdir}"

gac_cmd = "#{installdir}\\gacutil.exe /i #{installdir}\\Webtrends.RoadRunner.SSISPackageRunner.dll"
sc_cmd = "\"%WINDIR%\\System32\\sc.exe create WebtrendsRoadRunnerService binPath= #{installdir}\\Webtrends.RoadRunner.Service.exe obj= #{user} password= #{password}\""
netsh_cmd = "netsh http add urlacl url=http://+:8097/ user=#{user}"

directory "#{installdir}" do
	recursive true
	action :create
end

windows_zipfile "#{installdir}" do
	source "#{rr_url}"
	action :unzip	
	not_if {::File.exists?("#{installdir}\\Webtrends.RoadRunner.Service.exe")}
end

template "#{installdir}\\Webtrends.RoadRunner.Service.exe.config" do
	source "RRServiceConfig.erb"
	variables(		
		:master_host => node['wt_common']['master_host']
	)
end

template "#{installdir}\\log4net.config" do
	source "log4net.erb"
	variables(		
		:logdir => "#{node['wt_common']['install_dir']}\\logs"
	)
end

execute "gac" do
	command gac_cmd
	cwd installdir
	not_if { node[:rr_configured]}
end

execute "sc" do
	command sc_cmd
	cwd installdir
	not_if { node[:rr_installed]}
end

execute "netsh" do
	command netsh_cmd
	cwd installdir
	not_if { node[:rr_configured]}
end

service "WebtrendsRoadRunnerService" do
	action :start
end

ruby_block "install_flag" do
	block do
		node.set['rr_installed']
		node.save
	end
	action :create
end
