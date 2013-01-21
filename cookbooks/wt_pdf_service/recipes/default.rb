#
# Cookbook Name:: wt_pdf_service
# Recipe:: default
# Author: Michael Parsons (Michael.Parsons@webtrends.com)
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
# This recipe sets up the base configuration for pdf service


if ENV["deploy_build"] == "true" then
	include_recipe "wt_pdf_service::uninstall"
	include_recipe "ms_dotnet4::regiis"
end

# Properties
install_dir = node['wt_common']['install_dir_windows']
install_dir_app =  "#{node['wt_common']['install_dir_windows']}\\PDFService"
install_logdir = node['wt_common']['install_log_dir_windows']
user_data = data_bag_item('authorization', node.chef_environment)
app_pool_user = user_data['wt_common']['ui_user']
app_pool_password = user_data['wt_common']['ui_pass']
app_pool_name = node['wt_pdf_service']['app_pool_name']

# Create the directories
directory install_dir_app do
	action :create
	recursive true
end

# Create the site
iis_site 'PDFService' do
	protocol :http
	port node['wt_pdf_service']['website_port']
	action [:add, :start]
end

wt_base_firewall 'PDFWS' do
	protocol "TCP"
	port node['wt_pdf_service']['website_port']
	action[:open_port]
end

if ENV["deploy_build"] == "true"
	
	# Create the app pool
	iis_pool node['wt_pdf_service']['app_pool'] do
		pipeline_mode :Integrated
		runtime_version "4.0"
		thirty_two_bit :true
		action [:add, :config]
	end
	
	# Create the app
	iis_app "PDF" do
		path "/pdf"
		application_pool node['wt_pdf_service']['app_pool']
		physical_path install_dir_app
		action :add
	end

	windows_zipfile install_dir do
		source node['wt_pdf_service']['download_url'] 
		action :unzip
	end

	template "#{install_dir_app}\\Web.config" do
		source "webConfig.erb"
		variables(

		)
	end

	template "#{install_dir_app}\\log4net.config" do
		source "log4net.config.erb"
		variables(
			:log_level => node['wt_pdf_service']['log_level']
		)
	end

	share_wrs
end


#Post Install

wt_base_icacls install_dir do
	action :grant
	user user_data['wt_common']['ui_user']
	perm :read
end

execute "ServiceModelReg" do
	command	"%WINDIR%\\Microsoft.Net\\Framework64\\v4.0.30319\\ServiceModelReg.exe -r"
	action :run
end
