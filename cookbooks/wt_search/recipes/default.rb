#
# Cookbook Name:: wt_search
# Recipe:: default
# Author:: Kendrick Martin
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#
# This recipe installs the needed components to full setup/configure the Search service
#
require 'rest_client'
require 'rexml/document'
require 'json'
#include_recipe "wt_search::uninstall" if deploy_mode?

# source build
project_name = "Search"
pod = "CIPod"

build_data = data_bag_item('wt_builds', pod)
build_id = build_data[project_name]

base_url = 'http://teamcity.webtrends.corp/guestAuth/app/rest/builds/' + build_id

response = RestClient.get base_url
btID = nil
build_doc = REXML::Document.new(response.body)
build_doc.elements.each('//buildType') do |type|
	btID = type.attributes["id"]
end

url = "http://teamcity.webtrends.corp/repository/download/#{btID}:id/#{build_id}/#{node['wt_search']['artifact']}"

# get parameters
master_host = node['wt_common']['master_host']

# destinations
install_dir = "#{node['wt_common']['install_dir_windows']}#{node['wt_search']['install_dir']}"

# get data bag items 
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['loader_user']
svcpass = auth_data['wt_common']['loader_pass']

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

if deploy_mode?

	# unzip the install package
	windows_zipfile install_dir do
		source url
		action :unzip	
	end

	powershell "create service" do
		environment({'serviceName' => node['wt_search']['service_name'], 'install_dir' => install_dir, 'svcuser' => svcuser, 'svcpass' => svcpass})	
		code <<-EOH
 		# $computer = gc env:computername
 		$class = "Win32_Service"
		$method = "Create"
		# $mc = [wmiclass]"\\\\$computer\\ROOT\\CIMV2:$class"
		$mc = [wmiclass]"\\\\.\\ROOT\\CIMV2:$class"
		$servicePath = $env:install_dir + "\\Webtrends.Search.Service.exe"
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
	
end

service node['wt_search']['service_name'] do
	action :start
	ignore_failure true
end