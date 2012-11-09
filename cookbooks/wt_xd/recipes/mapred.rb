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

# paths for jobtracker
job_tracker_uri = search(:node, "role:hadoop_jobtracker AND chef_environment:#{node['wt_xd']['environment']}").first['fqdn']

# clean up old deploy
include_recipe 'wt_xd::mapred_undeploy' if deploy_mode?

# setup hadoop group
group 'hadoop'

# setup hadoop user
user 'hadoop' do
  comment 'Hadoop user'
  gid 'hadoop'
  home '/home/hadoop'
  shell '/bin/bash'
  supports :manage_home => true
end


# create directories
[install_dir, log_dir].each do |dir|
	directory dir do
  owner 'hadoop'
  group 'hadoop'
  recursive true
	end
end

# directory for any lock files
directory "/var/lock/webtrends" do
  owner "hadoop"
  group "hadoop"
  mode 00755
  action :create
  recursive
end


# deploy build
if deploy_mode?

	package 'unzip' do
	  action :install
	end

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
    search(:node, "role:zookeeper AND chef_environment:#{node['wt_xd']['environment']}").each do |n|
        zookeeper_quorum << n['fqdn']
  end
end
zookeeper_quorum = zookeeper_quorum.sort

# configure templates
%w[environment.properties hbase.properties log4j.mapreduce.fb.xml log4j.mapreduce.tw.xml].each do |template_file|
	template "#{install_dir}/conf/#{template_file}" do
  source "#{template_file}.erb"
  owner 'hadoop'
  group 'hadoop'
  mode  00644
  variables ({
  	# hbase config
  	:hbase_dc_id  => node['wt_analytics_ui']['fb_data_center_id'],
  	:hbase_pod_id => node['wt_common']['pod_id'],

  	# zookeeper config
  	:zookeeper_quorum     => zookeeper_quorum * ',',
  	:zookeeper_clientport => node['zookeeper']['client_port'],

  	# log level
  	:log_level => node['wt_xd']['log_level'],

  	# jobtracker uri
  	:job_tracker_uri => job_tracker_uri
  })
	end
end

# configure scripts
%w[MapReduceFB.sh MapReduceTW.sh].each do |template_file|
	template "#{install_dir}/#{template_file}" do
  source "#{template_file}.erb"
  owner 'hadoop'
  group 'hadoop'
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
  command "chown -R hadoop:hadoop \"#{dir}\""
  action :run
	end
end

# setup cron jobs
cron 'MapReduceFB' do
	user 'hadoop'
	minute '*/05'
	command File.join(install_dir, 'MapReduceFB.sh')
end

cron 'MapReduceTW' do
	user 'hadoop'
	minute '*/05'
	command File.join(install_dir, 'MapReduceTW.sh')
end
