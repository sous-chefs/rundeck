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

installdir = "#{node['webtrends']['installdir']}\\RoadRunner"
zip_file = node['webtrends']['roadrunner']['zip_file']
buildURLs = data_bag("buildURLs")
build_url = node['webtrends']['roadrunner']['url']
base_url = node['base_url']
url_extensions = node['url_extensions']

pod = node.chef_environment
pod_data = data_bag_item('common', pod)
master_host = pod_data['master_host']
user = pod_data['loader_user']
password = pod_data['loader_pass']


rr_url = "#{build_url}/#{zip_file}"

gac_cmd = "#{installdir}\\gacutil.exe /i #{installdir}\\Webtrends.RoadRunner.SSISPackageRunner.dll"
sc_cmd = "\"%WINDIR%\\System32\\sc.exe create WebtrendsRoadRunnerService binPath= #{installdir}\\Webtrends.RoadRunner.Service.exe obj= #{user} password= #{password}\""
netsh_cmd = "netsh http add urlacl url=http://+:8097/ user=#{user}"

windows_feature "NetFx3" do
	action :install
end

http_request "TestingConnection" do
  url "#{base_url}#{url_extensions}"
end

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
		:master_host => pod_data['master_host']
	)
end

template "#{installdir}\\log4net.config" do
	source "log4net.erb"
	variables(		
		:logdir => "#{node['webtrends']['installdir']}\\logs"
	)
end

ruby_block "install_flag" do
	block do
		node.set['rr_installed']
		node.save
	end
	action :nothing
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
	

