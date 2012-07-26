#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: vc2010
# Recipe:: vc2010x64
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

windows_package node['vc2010']['x64']['productname'] do
	source node['vc2010']['x64']['url']
	options "/passive"
	installer_type :custom
	action :install
	Chef::Log.info "Source: [#{node['vc2010']['x64']['productname']}] #{node['vc2010']['x64']['url']}"
end
