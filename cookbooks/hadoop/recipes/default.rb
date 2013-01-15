#
# Cookbook Name:: hadoop
# Recipe:: default
#
# Copyright 2012, Webtrends Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'java'

case node['platform_family']
when 'debian'
	package_list   = %w[libsnappy1 python-simplejson python-cjson]
	hadoop_version = node.hadoop_attrib(:version)[/(.*?)(-\d+)?$/, 1]  # strip out rpm revision
	java_home      = '/usr/lib/jvm/default-java/jre'
when 'rhel'
	package_list   = %w[snappy-devel python-simplejson python-cjson]
	hadoop_version = node.hadoop_attrib(:version)
	java_home      = '/usr/lib/jvm/java/jre'
end

package_list.each do |pkg|
	package pkg do
		action :install
	end
end

node.save # needed to populate attributes

# get servers in this cluster
if node.attribute?('wt_common') && node['wt_common'].attribute?('common_resource_environment')
	hadoop_chef_environment = node['wt_common']['common_resource_environment'] || node.chef_environment
else
	hadoop_chef_environment = node.chef_environment
end
hadoop_namenode       = hadoop_search('hadoop_primarynamenode', 1, hadoop_chef_environment)
raise Chef::Exceptions::RoleNotFound, "hadoop_primarynamenode role not found" unless hadoop_namenode.count == 1
hadoop_namenode       = hadoop_namenode.first
hadoop_backupnamenode = hadoop_search('hadoop_backupnamenode', 1, hadoop_chef_environment).first
hadoop_jobtracker     = hadoop_search('hadoop_jobtracker', 1, hadoop_chef_environment).first
hadoop_datanodes      = hadoop_search('hadoop_datanode', 1000, hadoop_chef_environment).sort

# determine local_dir (datanodes often have multiples disks, while namenode/jobtrackers do not)
query = "name:#{node.name} AND role:hadoop_datanode"
local_dir = search(:node, query).count == 1 ? node.hadoop_attrib(:mapred, :local_dir) : node.hadoop_attrib(:mapred, :non_datanode_local_dir)

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

# create the bashrc file for the hadoop user
cookbook_file '/home/hadoop/.bashrc' do
	source 'bashrc'
	owner 'hadoop'
	group 'hadoop'
	mode 00644
end

# setup ssh keys so we can use the easy cluster start/stop scripts
remote_directory '/home/hadoop/.ssh' do
	source 'ssh'
	owner 'hadoop'
	group 'hadoop'
	files_owner 'hadoop'
	files_group 'hadoop'
	files_mode 00600
	mode 00700
end

# create the install dir
directory node.hadoop_attrib(:install_dir) do
	owner 'hadoop'
	group 'hadoop'
	mode 00744
	recursive true
end

# install the hadoop rpm from our repo
package 'hadoop' do
	action :install
	version hadoop_version
end

# manage hadoop configs
%w[core-site.xml log4j.properties fair-scheduler.xml hadoop-env.sh hadoop-policy.xml hdfs-site.xml mapred-site.xml masters slaves taskcontroller.cfg mapred-queue-acls.xml].each do |template_file|
	template "/etc/hadoop/#{template_file}" do
		source "hadoop-conf/#{template_file}"
		mode 00755
		variables(
			:namenode       => hadoop_namenode,
			:jobtracker     => hadoop_jobtracker,
			:backupnamenode => hadoop_backupnamenode,
			:datanodes      => hadoop_datanodes,
			:local_dir      => local_dir,
			:java_home      => java_home
		)
	end
end

# set perms on hadoop startup scripts since the rpm has them wrong
%w[start-dfs.sh stop-dfs.sh start-mapred.sh stop-mapred.sh slaves.sh].each do |file_name|
	file "/usr/sbin/#{file_name}" do
		mode 00555
	end
end

# increase the file limits for the hadoop user
file '/etc/security/limits.d/123hadoop.conf' do
	owner 'root'
	group 'root'
	mode 00644
	content 'hadoop  -       nofile  32768'
	action :create
end
