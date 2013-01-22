#
# Cookbook Name:: wt_xd
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploy first"  
  include_recipe "wt_xd::importer_uninstall"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

download_url = node['wt_xd']['importer']['download_url']

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_xd']['importer']['install_dir']).gsub(/[\\\/]+/,"\\")
log_dir = File.join(node['wt_common']['install_dir_windows'], "logs")

# get data bag items
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']
svcpass = auth_data['wt_common']['system_pass']

# create the install directory
directory install_dir do
  recursive true
  action :create
  rights :write, auth_data['wt_common']['system_user']
  rights :read, auth_data['wt_common']['system_user']
end

directory log_dir do
  recursive true
  action :create
  rights :write, auth_data['wt_common']['system_user']
  rights :read,  auth_data['wt_common']['system_user']
end

if ENV["deploy_build"] == "true"

	# unzip the install package
	windows_zipfile install_dir do
		source download_url
		action :unzip
	end
	
    %w[Webtrends.ActionCenterControl.exe.config Webtrends.ExternalData.Refresh.exe.config Webtrends.ExternalData.RetrievalService.exe.config
    	Webtrends.ExternalData.StorageService.exe.config Webtrends.ExternalData.Common.dll.config Webtrends.ExternalData.Plugins.ExactTargetConnector.dll.config
    	Webtrends.ExternalData.StorageService.log4net.config].each do |template_file|
	  template "#{install_dir}\\#{template_file}" do
	  source "#{template_file}.erb"
	  variables({
	  	  :log_dir => log_dir,
		  :master_host => node['wt_masterdb']['host'],
		  :cass_host => node['cassandra']['cassandra_host'],
		  :report_column => node['cassandra']['cassandra_report_column'],
		  :thrift_port => node['cassandra']['cassandra_thrift_port'],
		  :metadata_column => node['cassandra']['cassandra_meta_column'],
		  :admin_email => node['wt_common']['admin_email'],
		  :support_email => node['wt_common']['tech_support_email'],
		  :target_email => node['wt_actioncenter']['exact_target_email'],
		  :bcc_email => node['wt_actioncenter']['bcc_email']
	  })
	  end
    end

  # Creates the services and issues initial startup commands
  xd_rs = File.join(install_dir, node['wt_xd']['retrieval']['service_binary']).gsub(/[\\\/]+/,"\\")
  execute xd_rs do
    command "#{xd_rs} --install --SERVICEACCOUNT=#{svcuser} --SERVICEPASS=#{svcpass}"
  end

  xd_ss = File.join(install_dir, node['wt_xd']['storage']['service_binary']).gsub(/[\\\/]+/,"\\")
  execute xd_ss do
    command "#{xd_ss} --install --SERVICEACCOUNT=#{svcuser} --SERVICEPASS=#{svcpass}"
  end
	
	share_wrs
end

service node['wt_xd']['retrieval']['service_name'] do
	action :start
end

service node['wt_xd']['storage']['service_name'] do
	action :start
end

