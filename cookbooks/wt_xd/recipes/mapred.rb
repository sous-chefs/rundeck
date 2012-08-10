#
# Cookbook Name:: wt_xd
# Recipe:: mapred
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

# sources
source_zipfile  = node['wt_xd']['download_url'][/\/([^\/\?]+)(\?.*)?$/, 1]
source_fullpath = File.join(Chef::Config[:file_cache_path], source_zipfile)

# destinations
install_dir = File.join(node['wt_common']['install_dir_linux'], 'wt_xd')
log_dir     = node['wt_common']['log_dir_linux']

# clean up old deploy
include_recipe 'wt_xd::mapred_undeploy' if deploy_mode?

# create directories
[install_dir, log_dir].each do |dir|
	directory dir do
		owner 'webtrends'
		group 'webtrends'
		recursive true
	end
end

# deploy build
if deploy_mode?
	package 'unzip'
	remote_file source_fullpath do
		source node['wt_xd']['download_url']
		mode 00644
	end
	execute 'unzip artifacts' do
		command "unzip -o #{source_fullpath} -d #{install_dir}"
		action :run
	end
	file source_fullpath do
		action :delete
	end
end

# get zookeeper nodes
zookeeper_quorum = Array.new
if not Chef::Config.solo
	search(:node, "role:zookeeper AND chef_environment:#{node.chef_environment}").each do |n|
		zookeeper_quorum << n[:fqdn]
	end
end
# fall back to attribs if search doesn't come up with any zookeeper nodes
if zookeeper_quorum.count == 0
	node[:zookeeper][:quorum].each do |i|
		zookeeper_quorum << i
	end
end

# configure templates
%w[environment.properties hbase.properties log4j.mapreduce.fb.xml log4j.mapreduce.tw.xml].each do |template_file|
	template "#{install_dir}/conf/#{template_file}" do
		source "#{template_file}.erb"
		owner 'webtrends'
		group 'webtrends'
		mode  00644
		variables ({
			# hbase config
			:hbase_dc_id  => node['hbase']['data_center_id'],
			:hbase_pod_id => node['hbase']['pod_id'],

			# zookeeper config
			:zookeeper_quorum     => zookeeper_quorum * ',',
			:zookeeper_clientport => node['zookeeper']['client_port'],

			# log level
			:log_level => node['wt_xd']['log_level']
		})
	end
end

# configure scripts
%w[MapReduceFB.sh MapReduceTW.sh].each do |template_file|
	template "#{install_dir}/#{template_file}" do
		source "#{template_file}.erb"
		owner 'webtrends'
		group 'webtrends'
		mode  00755
		variables ({
			# locations
			:install_dir => install_dir,
			:log_dir     => log_dir,
			:java_home   => node['java']['java_home']
		})
	end
end

# fix ownership
[install_dir, log_dir].each do |dir|
	execute dir do
		command "chown -R webtrends:webtrends \"#{dir}\""
		action :run
	end
end

# setup cron jobs
cron 'MapReduceFB' do
	user 'webtrends'
	minute '*/05'
	command File.join(install_dir, 'MapReduceFB.sh')
end
cron 'MapReduceTW' do
	user 'webtrends'
	minute '*/05'
	command File.join(install_dir, 'MapReduceTW.sh')
end
