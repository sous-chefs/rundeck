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
app_pool = "#{node['webtrends']['roadrunner']['app_pool']
zip_file = node['webtrends']['roadrunner']['zip_file']
buildURLs = data_bag("buildURLs")
build_url = data_bag_item('buildURLs', 'latest')

pod = node['webtrends']['pod']
pods = data_bag_item('common', pod)
master_host = pods['master_host']


rr_msi_url = build_url['url']
rr_msi_url << "roadrunner/"
rr_msi_url << zip_file

gac_cmd = "#{installdir}\\gacutil.exe /i #{installdir}\\Webtrends.RoadRunner.SSISPackageRunner.dll"
windows_feature "NetFx3" do
	action :install
end

iis_site 'Default Web Site' do
	action [:stop, :delete]
end

windows_zipfile "#{installdir}" do
	source "#{rr_msi_url}"
	action :unzip	
	not_if {::File.exists?("#{installdir}\\log4net.xml")}
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
	action :nothing
end

iis_pool "RoadRunner"
	pipeline_mode "Intergrated"
	runtime_version "4.0"
	action [:add, config]
end

iis_site 'RoadRunner' do
	protocol :http
    port 80
    path "#{installdir}"
	action [:add,:start]
end

iis_app "DX" do
	path "/RoadRunner"
	application_pool "#{app_pool}"
	physical_path "#{installdir}"
	action :add
end