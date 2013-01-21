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

def get_teamcity_branch (download_url)

	download_server = download_url[/^https?:\/\/([^\/]+)\//, 1]

	if download_url =~ /\b(bt\d+)\b/
		buildtype_id = $1
	else
		return false
	end

	tc = Teamcity.new(download_server, 80)

	tc.build_types.each do |bt|
		return "#{bt.project_name}_#{bt.name}".gsub(/ /, '_') if bt.id == buildtype_id
	end

end

def publish_version (params)

	role         = params[:role]
	download_url = params[:download_url]
	key_file     = params[:key_file]
	status       = params[:status] || 'Up'

	download_server = download_url[/^https?:\/\/([^\/]+)\//, 1]

	branch = get_teamcity_branch(download_url) || download_server

	pod_details_cmd = File.join(Chef::Config[:file_cache_path], 'PodDetails.ps1').gsub(/[\\\/]+/,'\\')
	pod_details_cmd << " -Credential WTENGLAB\\wtInstaller -Password Bijoux1"
	pod_details_cmd << " -Hostname '#{node['hostname']}'"
	pod_details_cmd << " -Pod '#{node.chef_environment}'"
	pod_details_cmd << " -Role '#{role}'"
	pod_details_cmd << " -KeyFile '#{key_file}'"
	pod_details_cmd << " -Status '#{status}'"
	pod_details_cmd << " -Branch '#{branch}'"
	pod_details_cmd << " -Version '#{ENV['wtver']}'" if ENV['wtver'] =~ /^\d/

	log (pod_details_cmd) { level :debug }

	powershell 'publish version' do
		code pod_details_cmd
		ignore_failure true
	end

end

%w{ PodDetails.ps1 Functions.ps1 }.each do |ps|
	cookbook_file "#{Chef::Config[:file_cache_path]}\\#{ps}" do
		source ps
		action :create
	end
end

# windows install directory
idir = node['wt_common']['install_dir_windows']

node['roles'].each do |r|
	case r
  		when 'wt_analytics_ui'
			log "publishing #{r}"
			publish_version(
				:role         => 'A10 UI',
				:download_url => node['wt_analytics_ui']['download_url'],
				:key_file     => File.join(idir, node['wt_analytics_ui']['install_dir'], 'bin/WebTrends.UI.Reporting.dll').gsub(/[\\\/]+/,'\\')
			)
		when 'wt_data_deleter'
			log "publishing #{r}"
			publish_version(
				:role         => 'Data Deleter',
				:download_url => node['wt_data_deleter']['download_url'],
				:key_file     => File.join(idir, node['wt_data_deleter']['install_dir'], 'DataDeleter.exe').gsub(/[\\\/]+/,'\\')
			)
		when 'wt_devicedataupdater'
			log "publishing #{r}"
			publish_version(
				:role         => 'Device Data Updater',
				:download_url => node['wt_devicedataupdater']['download_url'],
				:key_file     => File.join(idir, node['wt_devicedataupdater']['install_dir'], 'DDU.exe').gsub(/[\\\/]+/,'\\')
			)
		when 'wt_logpreproc'
			log "publishing #{r}"
			publish_version(
				:role         => 'LPP',
				:download_url => node['wt_logpreproc']['download_url'],
				:key_file     => File.join(idir, node['wt_logpreproc']['install_dir'], 'wtlogpreproc.exe').gsub(/[\\\/]+/,'\\')
			)
		when 'wt_platformscheduler_agent'
			log "publishing #{r}"
			publish_version(
				:role         => 'Platform Scheduler Agent',
				:download_url => node['wt_platformscheduler']['agent']['download_url'],
				:key_file     => File.join(idir, 'common/agent/Webtrends.Agent.exe').gsub(/[\\\/]+/,'\\')
			)
  		when 'wt_roadrunner'
  			log "publishing #{r}"
  			publish_version(
				:role         => 'RoadRunner Service',
				:download_url => node['wt_roadrunner']['download_url'],
				:key_file     => File.join(idir, node['wt_roadrunner']['install_dir'], 'Webtrends.RoadRunner.Service.exe').gsub(/[\\\/]+/,'\\')
			)
  		when 'wt_search'
  			log "publishing #{r}"
  			publish_version(
				:role         => 'Search Service',
				:download_url => node['wt_search']['download_url'],
				:key_file     => File.join(idir, node['wt_search']['install_dir'], 'Webtrends.Search.Service.exe').gsub(/[\\\/]+/,'\\')
			)
  		when 'wt_sync'
  			log "publishing #{r}"
  			publish_version(
				:role         => 'Sync Service',
				:download_url => node['wt_sync']['download_url'],
				:key_file     => File.join(idir, node['wt_sync']['install_dir'], 'Webtrends.SyncService.exe').gsub(/[\\\/]+/,'\\')
			)
  		else
    		log "no publishing data for role  => #{r}"
	end
end
