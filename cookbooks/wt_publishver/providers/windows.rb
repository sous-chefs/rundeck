#
# Cookbook Name:: wt_publishver
# Provider:: windows
# Author:: David Dvorak(<david.dvorakd@webtrends.com>)
#
# Copyright 2013, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

action :deploy_prereqs do

	%w{ PodDetails.ps1 PodDetailsLib.ps1 }.each do |ps|
		cookbook_file "#{Chef::Config[:file_cache_path]}\\#{ps}" do
			source ps
			action :create
		end
	end

	require 'rest_client'
	require 'rexml/document'

end

action :update do

	Chef::Log.debug("Running #{@new_resource.name} in #{@new_resource.provider} from #{@new_resource.cookbook_name}::#{@new_resource.recipe_name}")

	download_server = @new_resource.download_url[/^https?:\/\/([^\/]+)\//, 1]

	# version (should start with a digit)
	version = ENV['wtver'] if ENV['wtver'] =~ /^\d/

	# branch
	branch = get_teamcity_branch(@new_resource.download_url) || download_server

	# set status
	case @new_resource.status
	when :up
		status = 'Up'
	when :down
		status = 'Down'
	when :pending
		status = 'Pending'
	when :unknown
		status = 'Unknown'
	end

	pod_details_cmd = ::File.join(Chef::Config[:file_cache_path], 'PodDetails.ps1').gsub(/[\\\/]+/,'\\')
	pod_details_cmd << " -Credential WTENGLAB\\wtInstaller -Password Bijoux1"
	pod_details_cmd << " -Hostname '#{node['hostname']}'"
	pod_details_cmd << " -Pod '#{node.chef_environment}'"
	pod_details_cmd << " -Role '#{@new_resource.role}'"
	pod_details_cmd << " -KeyFile '#{@new_resource.key_file}'"
	pod_details_cmd << " -Status '#{status}'"
	pod_details_cmd << " -Branch '#{branch}'"
	pod_details_cmd << " -Version '#{ENV['wtver']}'" if ENV['wtver'] =~ /^\d/
	pod_details_cmd << " -SelectVersion '#{@new_resource.select_version}'" if @new_resource.select_version

	log (pod_details_cmd) { level :debug }

	powershell 'publish version' do
		code pod_details_cmd
		ignore_failure true
	end

end

private

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
