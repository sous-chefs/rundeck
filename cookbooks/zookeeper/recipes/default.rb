#
# Cookbook Name:: zookeeper
# Recipe:: default
# Author:: sean.mcnamara@webtrends.com / tim.smith@webtrends.com
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute

# This recipe installs the needed components to prepare machine for db_index exe

include_recipe 'java'
include_recipe 'runit'

source_tarball  = node.zookeeper_attrib(:download_url)[/\/([^\/\?]+)(\?.*)?$/, 1]
source_fullpath = File.join(Chef::Config[:file_cache_path], source_tarball)

# servers in this cluster
zookeeper_nodes = zookeeper_search('zookeeper').sort
if zookeeper_nodes.count == 0
	# in single node cluster, role is never found in search until node state is saved.
	node.save
	zookeeper_nodes = zookeeper_search('zookeeper').sort
	raise Chef::Exceptions::RoleNotFound, "zookeeper role not found" if zookeeper_nodes.count == 0
end

# setup zookeeper group
group 'zookeeper'

# setup zookeeper user
user 'zookeeper' do
	comment 'ZooKeeper user'
	gid 'zookeeper'
	home '/home/zookeeper'
	shell '/bin/false'
end

# create the config directory
directory node.zookeeper_attrib(:config_dir) do
	owner 'root'
	group 'root'
	recursive true
	mode 00755
end

# create the install directory
directory node.zookeeper_attrib(:install_dir) do
	owner 'zookeeper'
	group 'zookeeper'
	recursive true
	mode 00744
end

# create the data directory
directory node.zookeeper_attrib(:data_dir) do
	owner 'zookeeper'
	group 'zookeeper'
	recursive true
	mode 00744
end

# create the snapshot directory
directory node.zookeeper_attrib(:snapshot_dir) do
	owner 'zookeeper'
	group 'zookeeper'
	recursive true
	mode 00744
end

# create the log directory
directory node.zookeeper_attrib(:log_dir) do
	owner 'zookeeper'
	group 'zookeeper'
	recursive true
	mode 00744
end

# force ownership change in case these directories were created by other means
[ node.zookeeper_attrib(:install_dir), node.zookeeper_attrib(:data_dir), node.zookeeper_attrib(:snapshot_dir), node.zookeeper_attrib(:log_dir) ].each do |dir|
	execute dir do
		command "chown -R zookeeper:zookeeper #{dir}"
		action :run
	end
end

# download zookeeper
remote_file source_fullpath do
	source node.zookeeper_attrib(:download_url)
	owner 'zookeeper'
	group 'zookeeper'
	mode 00744
	action :create_if_missing
end

# extract it
execute 'extract-zookeeper' do
	command "tar -zxf #{source_fullpath}"
	creates "#{node.zookeeper_attrib(:install_dir)}/zookeeper-#{node.zookeeper_attrib(:version)}"
	cwd node.zookeeper_attrib(:install_dir)
	user 'zookeeper'
	group 'zookeeper'
end

# create a link from the specific version to a generic zookeeper folder
link "#{node.zookeeper_attrib(:install_dir)}/current" do
	owner 'zookeeper'
	group 'zookeeper'
	to "#{node.zookeeper_attrib(:install_dir)}/zookeeper-#{node.zookeeper_attrib(:version)}"
end

# delete original config folder so there's no confusion about which is the real config location
directory "#{node.zookeeper_attrib(:install_dir)}/current/conf" do
	recursive true
	action :delete
end

# manage configs
%w[configuration.xsl java.env log4j.properties zoo.cfg].each do |template_file|
	template "#{node.zookeeper_attrib(:config_dir)}/#{template_file}" do
		source "#{template_file}.erb"
		owner 'root'
		group 'root'
		mode 00644
		variables({
			:quorum => zookeeper_nodes
		})
	end
end

file "#{node.zookeeper_attrib(:data_dir)}/myid" do
	owner 'zookeeper'
	group 'zookeeper'
	mode 00644
	content (zookeeper_nodes.index(node[:fqdn]) + 1).to_s
end

# configure start script (the true startup script is in /etc/service)
template "#{node.zookeeper_attrib(:install_dir)}/current/bin/zkServer.sh" do
	source 'zkServer.sh.erb'
	mode 00755
	owner 'zookeeper'
	group 'zookeeper'
	variables({
		:java_jmx_port => node.zookeeper_attrib(:jmx_port)
	})
end

# setup snapshot roller cron job
template '/etc/cron.hourly/zkRollSnapshot' do
	source 'zkRollSnapshot.erb'
	owner 'zookeeper'
	group 'zookeeper'
	mode 00555
end

# stop zookeeper if setting up runit service for the first time
execute 'zookeeper-manual-stop' do
	command "#{node.zookeeper_attrib(:install_dir)}/current/bin/zkServer.sh stop"
	not_if { File.exists?("#{node[:runit][:sv_dir]}/zookeeper") }
end

# setup service
runit_service 'zookeeper' do
	options({
		:java_jmx_port => node.zookeeper_attrib(:jmx_port)
	})
end

service 'zookeeper' do
	subscribes :restart, resources(
		:template => "#{node.zookeeper_attrib(:config_dir)}/zoo.cfg",
		:link     => "#{node.zookeeper_attrib(:install_dir)}/current"
	)
end

# create collectd plugin for zookeeper if collectd has been applied.
if node.attribute?('collectd')
	template "#{node[:collectd][:plugin_conf_dir]}/collectd_zookeeper.conf" do
		source "collectd_zookeeper.conf.erb"
		owner 'root'
		group 'root'
		mode 00644
		notifies :restart, resources(:service => 'collectd')
	end
end
