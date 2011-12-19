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
build_url = data_bag_item('buildURLs', 'latest')

pod = node['webtrends']['pod']
pods = data_bag_item('pods', pod)
master_host = pods['master_host']
service_acct = pods['system_user']
service_pass = pods['system_pass']

rr_msi_url = build_url['url']
rr_msi_url << "roadrunner/"
rr_msi_url << zip_file

install_cmd = "#{installdir}\\installutil.exe /INSTALLDIR=#{installdir} /MASTER_HOST=#{master_host} /STANDALONE=TRUE"
install_cmd << " /SERVICEACCT=#{service_acct} /SERVICEPASS=#{service_pass} "
install_cmd << "#{installdir}\\Webtrends.RoadRunner.Service.exe"

gac_cmd = "#{installdir}\\gacutil.exe /i #{installdir}\\Webtrends.RoadRunner.SSISPackageRunner.dll"
windows_feature "NetFx3" do
	action :install
end

directory installdir do
	action :create
	recursive true
end

windows_zipfile "#{installdir}" do
	source "#{rr_msi_url}"
	action :unzip
	notifies :create, "ruby_block[install_flag]", :immediately
	notifies :run, "execute[gac]", :immediately
	notifies :run, "execute[install]", :immediately
	not_if {node.attribute?("rr_installed")}
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

execute "install" do
	command install_cmd
	cwd installdir
	action :nothing
end

service "WebtrendsRoadRunnerService" do
	action :start
end