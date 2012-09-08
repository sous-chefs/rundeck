#
# Cookbook Name:: hadoop
# Recipe:: namenode
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

include_recipe 'hadoop'

name_dir_current = File.join(node.hadoop_attrib(:dfs, :name_dir), 'current')

directory name_dir_current do
	owner 'hadoop'
	group 'hadoop'
	mode 00755
	recursive true
	action :create
end

# correct permissions 
execute 'chown namenode' do
	d = File.expand_path('..', node.hadoop_attrib(:dfs, :name_dir))
	command "chown -R hadoop:hadoop #{d}"
	only_if do
		f = File.stat(d)
		f.uid == 0 || f.gid == 0
	end
end

# Create the mapred.exclude file for decommissioning nodes if it doesn't exist
file '/etc/hadoop/mapred.exclude' do
	owner 'root'
	group 'root'
	mode 00755
	action :create_if_missing
end

# Create collectd plugin for hadoop name node if collectd has been applied.
if node.attribute?('collectd')
	template "#{node[:collectd][:plugin_conf_dir]}/collectd_hadoop_NameNode.conf" do
		source 'collectd_hadoop_NameNode.conf.erb'
		owner 'root'
		group 'root'
		mode 00644
		notifies :restart, resources(:service => 'collectd')
	end
end
