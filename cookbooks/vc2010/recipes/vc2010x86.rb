#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: vc2010
# Recipe:: vc2010x86
#
# Copyright 2011, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

windows_package node['vc2010']['x86']['productname'] do
	source node['vc2010']['x86']['url']
	options "/passive"
	installer_type :custom
	action :install
	Chef::Log.info "Source: [#{node['vc2010']['x86']['productname']}] #{node['vc2010']['x86']['url']}"
end
