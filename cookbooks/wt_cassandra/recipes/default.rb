#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: wt_cassandra
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

yum_repository "wtlab" do
	name "wtlab"
	description "Webtrends Lab"
	url "http://sops01.staging.dmz/repo/centos/wtlab"
	action :add
end
