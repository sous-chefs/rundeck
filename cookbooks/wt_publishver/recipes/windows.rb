#
# Cookbook Name:: wt_publishver
# Recipe:: windows
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

require 'rest_client'
require 'rexml/document'
require 'teamcity-rest-client'

def publish_version (role, branch, key_file, status)

	pod_details_cmd = "#{Chef::Config[:file_cache_path]}\\PodDetails.ps1 -Credential WTENGLAB\\wtInstaller -Password Bijoux1"
	pod_details_cmd << " -Hostname '#{node['hostname']}'"
	pod_details_cmd << " -Pod '#{node.chef_environment}'"
	pod_details_cmd << " -Role '#{role}'"
	pod_details_cmd << " -KeyFile '#{key_file}'"
	pod_details_cmd << " -Status '#{status}'"
	pod_details_cmd << " -Branch '#{branch}'"

	log pod_details_cmd
	
	powershell 'publish version' do
		command pod_details_cmd
		flags '-NonInteractive'
		ignore_failure true
	end
	
end

%w{ PodDetails.ps1 Functions.ps1 }.each do |ps|
	cookbook_file "#{Chef::Config[:file_cache_path]}\\#{ps}" do
		source ps
		action :create_if_missing
	end
end

#node['roles'].each do |r|
%w{ webtrends_server wt_analytics_ui iis }.each do |r|
	case r
  		when 'wt_analytics_ui'
			log "publishing #{r}"
#			publish_version(
#				'A10 UI',
#				node['wt_analytics_ui']['download_url'],
#				# File.join(node['wt_common']['install_dir_windows'], node['wt_analytics_ui']['install_dir'], 'bin/WebTrends.UI.Reporting.dll').gsub(/[\\\/]+/,"\\"),
#				File.join(node['wt_common']['install_dir_windows'], 'Analytics/bin/WebTrends.UI.Reporting.dll').gsub(/[\\\/]+/,"\\"),
#				'Up'
#			)
  		when 'wt_search'
  		when 'wt_sync'
  		else
    		log "no publishing data for role  => #{r}"
	end
end
