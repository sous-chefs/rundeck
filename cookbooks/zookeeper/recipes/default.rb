#
# Cookbook Name:: zookeeper
# Recipe:: default
# Author:: sean.mcnamara@webtrends.com / tim.smith@webtrends.com
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute

# This recipe installs the needed components to prepare machine for db_index exe

include_recipe "java"
include_recipe "runit"

# setup zookeeper group
group "zookeeper" do
end

# setup zookeeper user
user "zookeeper" do
	comment "ZooKeeper user"
	gid "zookeeper"
	home "/home/zookeeper"
	shell "/bin/false"
end

# create the config directory
directory "#{node[:zookeeper][:config_dir]}" do
	owner "root"
	group "root"
	recursive true
	mode 00755
end

# create the install directory
directory "#{node[:zookeeper][:install_dir]}" do
	owner "zookeeper"
	group "zookeeper"
	recursive true
	mode 00744
end

# create the data directory
directory "#{node[:zookeeper][:data_dir]}" do
	owner "zookeeper"
	group "zookeeper"
	recursive true
	mode 00744
end

# create the snapshot directory
directory "#{node[:zookeeper][:snapshot_dir]}" do
	owner "zookeeper"
	group "zookeeper"
	recursive true
	mode 00744
end

# create the log directory
directory "#{node[:zookeeper][:log_dir]}" do
	owner "zookeeper"
	group "zookeeper"
	recursive true
	mode 00744
end

# force ownership change in case these directories were created by other means
[ node[:zookeeper][:install_dir], node[:zookeeper][:data_dir], node[:zookeeper][:snapshot_dir], node[:zookeeper][:log_dir] ].each do |dir|
	execute dir do
		command "chown -R zookeeper:zookeeper #{dir}"
		action :run
	end
end

# download zookeeper
remote_file "#{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz" do
	source "#{node[:zookeeper][:download_url]}"
	owner "zookeeper"
	group "zookeeper"
	mode 00744
	action :create_if_missing
end

# extract it
execute "extract-zookeeper" do
	command "tar -zxf #{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz"
	creates "#{node[:zookeeper][:install_dir]}/zookeeper-#{node[:zookeeper][:version]}"
	cwd "#{node[:zookeeper][:install_dir]}"
	user "zookeeper"
	group "zookeeper"
end

# create a link from the specific version to a generic zookeeper folder
link "#{node[:zookeeper][:install_dir]}/current" do
	to "#{node[:zookeeper][:install_dir]}/zookeeper-#{node[:zookeeper][:version]}"
end

# delete original config folder so there's no confusion about which is the real config location
directory "#{node[:zookeeper][:install_dir]}/current/conf" do
	recursive true
	action :delete
end

# manage configs
%w[configuration.xsl java.env log4j.properties zoo.cfg].each do |template_file|
	template "#{node[:zookeeper][:config_dir]}/#{template_file}" do
		source "#{template_file}"
		mode 00644
		owner "root"
		group "root"
		variables({
			:quorum => node[:zookeeper][:quorum]
		})
	end
end

# configure start script (the true startup script is in /etc/service)
template "#{node[:zookeeper][:install_dir]}/current/bin/zkServer.sh" do
	source "zkServer.sh"
	mode 00755
	owner "zookeeper"
	group "zookeeper"
	variables({
		:java_jmx_port => 10201
	})
end
  
# myid
template "#{node[:zookeeper][:data_dir]}/myid" do
	source "myid"
	owner "zookeeper"
	group "zookeeper"
	mode 00644
end

# setup snapshot roller cron job
template "/etc/cron.hourly/zkRollSnapshot" do
	source "zkRollSnapshot"
	owner "zookeeper"
	group "zookeeper"
	mode 00555
end

# stop zookeeper if setting up runit service for the first time
execute "zookeeper-manual-stop" do
	command "#{node[:zookeeper][:install_dir]}/current/bin/zkServer.sh stop"
	not_if { File.exists?("#{node[:runit][:sv_dir]}/zookeeper") }
end

# setup service
runit_service "zookeeper" do
	options({
		:java_jmx_port => 10201
	})
end

service "zookeeper" do
	subscribes :restart, resources(:template => "#{node[:zookeeper][:config_dir]}/zoo.cfg")
end

# create collectd plugin for zookeeper if collectd has been applied.
if node.attribute?("collectd")
	template "#{node[:collectd][:plugin_conf_dir]}/collectd_zookeeper.conf" do
		source "collectd_zookeeper.conf.erb"
		owner "root"
		group "root"
		mode 00644
		notifies :restart, resources(:service => "collectd")
	end
end
