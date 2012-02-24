#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: wt_cassandra
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

yum_repository node['wt_yum']['repo'] do
	name node['wt_yum']['name']
	description node['wt_yum']['description']
	url node['wt_yum']['url']
	action :add
end

package "apache-cassandra1" do
	action :install
end
