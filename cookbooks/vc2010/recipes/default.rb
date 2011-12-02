#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: vc2010
# Recipe:: default
#
# Copyright 2011, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

common = data_bag_item('global','common')
baserepo_url = common['baserepo_url']

unless baserepo_url.nil? || baserepo_url.empty?
	node.default['vc2010x86']['url'] = "#{baserepo_url}/repo/windows/vc2010/vcredist_x86.exe"
	node.default['vc2010x64']['url'] = "#{baserepo_url}/repo/windows/vc2010/vcredist_x64.exe"
end

file_x86 = ::File.basename(node['vc2010x86']['url'])
file_x64 = ::File.basename(node['vc2010x64']['url'])

cachefile_x86 = "#{Chef::Config[:file_cache_path]}/#{file_x86}"
cachefile_x64 = "#{Chef::Config[:file_cache_path]}/#{file_x64}"

remote_file cachefile_x86 do
	source node['vc2010x86']['url']
	checksum node['vc2010x86']['checksum']
	action :nothing
end

remote_file cachefile_x64 do
	source node['vc2010x64']['url']
	checksum node['vc2010x64']['checksum']
	action :nothing
end

http_request "HEAD #{node['vc2010x86']['url']}" do
	message ""
	url node['vc2010x86']['url']
	action :head
	if File.exists?(cachefile_x86)
	  headers "If-Modified-Since" => File.mtime(cachefile_x86).httpdate
	end
	notifies :create, resources(:remote_file => cachefile_x86), :immediately
end

http_request "HEAD #{node['vc2010x64']['url']}" do
	message ""
	url node['vc2010x64']['url']
	action :head
	if File.exists?(cachefile_x64)
	  headers "If-Modified-Since" => File.mtime(cachefile_x64).httpdate
	end
	notifies :create, resources(:remote_file => cachefile_x64), :immediately
end

execute file_x86 do
	command "#{cachefile_x86} /passive"
	action :run
end

execute file_x64 do
	command "#{cachefile_x64} /passive"
	action :run
end

