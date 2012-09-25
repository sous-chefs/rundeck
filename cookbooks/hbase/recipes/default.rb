#
# Cookbook Name:: hbase
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

# hbase requires hadoop to be installed
include_recipe 'hadoop'

node.save # needed to populate attributes

# get servers in this cluster
hadoop_namenode = hadoop_search('hadoop_primarynamenode', 1)
raise Chef::Exceptions::RoleNotFound, "hadoop_primarynamenode role not found" unless hadoop_namenode.count == 1
hadoop_namenode = hadoop_namenode.first

hmaster         = hbase_search('hbase_hmaster', 1).first
# backup_master   = hbase_search('hadoop_backupnamenode', 1).first
regionservers   = hbase_search('hbase_regionserver').sort
zookeeper_nodes = zookeeper_search('zookeeper').sort

source_tarball  = node.hbase_attrib(:download_url)[/\/([^\/\?]+)(\?.*)?$/, 1]
source_fullpath = File.join(Chef::Config[:file_cache_path], source_tarball)
hadoop_version  = node.hadoop_attrib(:version)[/(.*?)(-\d+)?$/, 1]  # strip out rpm revision

# download hbase tar.gz
remote_file source_fullpath do
	source node.hbase_attrib(:download_url)
	owner 'hadoop'
	group 'hadoop'
	mode 00744
	not_if "test -f #{source_fullpath}"
end

# remove old hadoop core file
execute 'remove hadoop-core' do
	command "for i in hadoop-core-*.jar; do [ \"$i\" != \"hadoop-core-#{hadoop_version}.jar\" ] && rm -f $i; done"
	cwd '/usr/share/hbase/lib'
	returns [0, 1]
	action :nothing
end

# extract the tar.gz
execute 'extract-hbase' do
	command "tar -zxf #{source_fullpath}"
	creates "hbase-#{node.hbase_attrib(:version)}"
	cwd "#{node.hadoop_attrib(:install_dir)}"
	user 'hadoop'
	group 'hadoop'
	notifies :run, resources(:execute => 'remove hadoop-core')
end

# link from the specific version of hbase to a generic path
link '/usr/share/hbase' do
	owner 'hadoop'
	group 'hadoop'
	to "#{node.hadoop_attrib(:install_dir)}/hbase-#{node.hbase_attrib(:version)}"
end

# hbase needs right hadoop core
link "/usr/share/hbase/lib/hadoop-core-#{hadoop_version}.jar" do
	owner 'hadoop'
	group 'hadoop'
	to "/usr/share/hadoop/hadoop-core-#{hadoop_version}.jar"
end

# create the log dir
directory node.hbase_attrib(:log_dir) do
	action :create
	owner 'hadoop'
	group 'hadoop'
	mode 00755
end

# is this file actually used by anything? -dvorak
file '/usr/share/hbase/conf/masters' do
	owner 'root'
	group 'root'
	mode 00644
	content hmaster
end

## TODO:  add a backup-master role
#file '/usr/share/hbase/conf/backup-masters' do
#	owner 'root'
#	group 'root'
#	mode 00644
#	content backup_master
#end

file '/usr/share/hbase/conf/regionservers' do
	owner 'root'
	group 'root'
	mode 00644
	content regionservers.join("\n")
end

# manage configs
%w[hbase-env.sh hbase-site.xml log4j.properties].each do |template_file|
	template "/usr/share/hbase/conf/#{template_file}" do
		source "#{template_file}"
		mode 00755
		variables(
			:namenode        => hadoop_namenode,
			:regionservers   => regionservers,
			:zookeeper_nodes => zookeeper_nodes
		)
	end
end

# add hbase to path
file '/etc/profile.d/hbase.sh' do
	owner 'root'
	group 'root'
	mode 00644
	content 'export PATH=$PATH:/usr/share/hbase/bin'
	action :create_if_missing
end
