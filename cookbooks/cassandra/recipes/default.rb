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

# Drop the JNA Jar.
bash "installJNA" do
user "root"
  code <<-EOH
  if [ ! -e /usr/share/cassandra/lib/jna.jar ]; then
    wget #{node['cassandra']['jna_url']} -O /usr/share/cassandra/lib/jna.jar
    chown cassandra /usr/share/cassandra/lib/jna.jar
    chmod 755 /usr/share/cassandra/lib/jna.jar
  fi
  EOH
end

# Drop MX4J jar.
bash "installMX4J" do
user "root"
  cwd "#{Chef::Config[:file_cache_path]}"
  code <<-EOH
  if [ ! -e /usr/share/cassandra/lib/mx4j-tools.jar ]; then
    wget #{node['cassandra']['mx4j_url']}
    tar zxvf mx4j-3.0.2.tar.gz mx4j-3.0.2/lib/mx4j-tools.jar
    cp mx4j-3.0.2/lib/mx4j-tools.jar /usr/share/cassandra/lib/
    chown cassandra:cassandra /usr/share/cassandra/lib/mx4j-tools.jar
    chmod 755 /usr/share/cassandra/lib/mx4j-tools.jar
  fi
  EOH
end

#Create collectd plugin for cassandra
template "#{node[:collectd][:plugin_conf_dir]}/#{file}.conf" do
  source "collectd_cassandra.conf.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, resources(:service => "collectd")
end
