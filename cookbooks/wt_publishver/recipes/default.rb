#
# Cookbook Name:: wt_publishver
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# old ubuntu platforms are not supported
return if node['platform_family'] == 'debian' && node['platform_version'].to_i < 12

#
# install prerequisites
#
wt_publishver 'Install Prerequisites' do
	action :deploy_prereqs
end

# linux install directory
ldir = node['wt_common']['install_dir_linux']


# windows install directory
wdir = node['wt_common']['install_dir_windows']

node['roles'].each do |r|
	case r
	when 'wt_analytics_ui'
		log "publishing #{r}"
		wt_publishver 'A10 UI' do
			download_url node['wt_analytics_ui']['download_url']
			key_file     File.join(wdir, node['wt_analytics_ui']['install_dir'], 'bin/WebTrends.UI.Reporting.dll').gsub(/[\\\/]+/,'\\')
		end
	when 'wt_data_deleter'
		log "publishing #{r}"
		wt_publishver 'Data Deleter' do
			download_url node['wt_data_deleter']['download_url']
			key_file     File.join(wdir, node['wt_data_deleter']['install_dir'], 'DataDeleter.exe').gsub(/[\\\/]+/,'\\')
		end
	when 'wt_devicedataupdater'
		log "publishing #{r}"
		wt_publishver 'Device Data Updater' do
			download_url node['wt_devicedataupdater']['download_url']
			key_file     File.join(wdir, node['wt_devicedataupdater']['install_dir'], 'DDU.exe').gsub(/[\\\/]+/,'\\')
		end
	when 'wt_logpreproc'
		log "publishing #{r}"
		wt_publishver 'LPP' do
			download_url node['wt_logpreproc']['download_url']
			key_file     File.join(wdir, node['wt_logpreproc']['install_dir'], 'wtlogpreproc.exe').gsub(/[\\\/]+/,'\\')
		end
	when 'wt_platformscheduler_agent'
		log "publishing #{r}"
		wt_publishver 'Platform Scheduler Agent' do
			download_url node['wt_platformscheduler']['agent']['download_url']
			key_file     File.join(wdir, 'common/agent/Webtrends.Agent.exe').gsub(/[\\\/]+/,'\\')
		end
	when 'wt_roadrunner'
		log "publishing #{r}"
		wt_publishver 'RoadRunner Service' do
			download_url node['wt_roadrunner']['download_url']
			key_file     File.join(wdir, node['wt_roadrunner']['install_dir'], 'Webtrends.RoadRunner.Service.exe').gsub(/[\\\/]+/,'\\')
		end
	when 'wt_sauth'
		log "publishing #{r}"
		wt_publishver 'Streaming Auth' do
			download_url node['wt_sauth']['download_url']
			key_file     File.join(wdir, 'Webtrends.Auth/bin/Webtrends.Auth.dll').gsub(/[\\\/]+/,'\\')
		end
	when 'wt_search'
		log "publishing #{r}"
		wt_publishver 'Search Service' do
			download_url node['wt_search']['download_url']
			key_file     File.join(wdir, node['wt_search']['install_dir'], 'Webtrends.Search.Service.exe').gsub(/[\\\/]+/,'\\')
		end
	when 'wt_streaming_api_server'
		log "publishing #{r}"
		wt_publishver 'Streaming API' do
			download_url node['wt_streamingapi']['download_url']
			key_file     File.join(ldir, 'streamingapi/lib/webtrends-streamingapi.jar')
		end
	when 'wt_streaming_viz'
		log "publishing #{r}"
		wt_publishver 'Streaming Viz' do
			download_url node['wt_streaming_viz']['download_url']
			key_file     File.join(wdir, 'Webtrends.Streaming.Viz/bin/Webtrends.Streaming.Viz.dll').gsub(/[\\\/]+/,'\\')
		end
	when 'wt_sync'
		log "publishing #{r}"
		wt_publishver 'Sync Service' do
			download_url node['wt_sync']['download_url']
			key_file     File.join(wdir, node['wt_sync']['install_dir'], 'Webtrends.SyncService.exe').gsub(/[\\\/]+/,'\\')
		end
	else
		log "no publishing data for role => #{r}"
	end
end
