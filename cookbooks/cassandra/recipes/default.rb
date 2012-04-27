#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: cassandra
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

build_uri = node['cassandra']['build_uri']
if (build_uri =~ /\/([^\/]*)$/)
	rpmfile = $1
end

package "apache-cassandra1" do
	action :install
	ignore_failure true
end

remote_file "#{Chef::Config[:file_cache_path]}/#{rpmfile}" do
	source build_uri
	not_if "rpm -qa | egrep -q apache-cassandra1"
	notifies :install, "rpm_package[apache-cassandra1]", :immediately
end

rpm_package "apache-cassandra1" do
	source "#{Chef::Config[:file_cache_path]}/#{rpmfile}"
	only_if {::File.exists?("#{Chef::Config[:file_cache_path]}/#{rpmfile}")}
	action :nothing
end

file "apache-cassandra1" do
	path "#{Chef::Config[:file_cache_path]}/#{rpmfile}"
	action :delete
end