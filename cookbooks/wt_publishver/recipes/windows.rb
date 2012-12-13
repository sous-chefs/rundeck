#
# Cookbook Name:: wt_publishver
# Recipe:: windows
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

def publish_version (role, build_dir, key_file, status)
	pd_cmd = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -NonInteractive -ExecutionPolicy RemoteSigned -Command \\\\sstore02.staging.dmz\\install\\adm\\PodDetails.ps1 -Credential WTENGLAB\\wtInstaller -Password Bijoux1'
	cmd = "#{pd_cmd} -Hostname '#{node['hostname']}' -Pod '#{node.chef_environment}' -Role '#{role}' -BuildDir '#{build_dir}' -KeyFile '#{key_file}' -Status '#{status}'"
	log cmd
	execute 'publish_version_ps' do
		command cmd
		ignore_failure true
	end
end

#node['roles'].each do |r|
%w{ webtrends_server wt_analytics_ui iis }.each do |r|
	case r
  		when 'wt_analytics_ui'
			log "publishing #{r}"
			publish_version(
				'A10 UI',
				node['wt_analytics_ui']['download_url'],
				# File.join(node['wt_common']['install_dir_windows'], node['wt_analytics_ui']['install_dir'], 'bin/WebTrends.UI.Reporting.dll').gsub(/[\\\/]+/,"\\"),
				File.join(node['wt_common']['install_dir_windows'], 'Analytics/bin/WebTrends.UI.Reporting.dll').gsub(/[\\\/]+/,"\\"),
				'Up'
			)
  		when 'wt_search'
  		when 'wt_sync'
  		else
    		log "no publishing data for role  => #{r}"
	end
end
