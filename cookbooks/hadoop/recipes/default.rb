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
include_recipe "java"

%w[snappy-devel python-simplejson python-cjson].each do |pkg|
  package pkg do
    action :install
  end
end

hadoop_namenode = search(:node, "role:hadoop_primarynamenode AND chef_environment:#{node.chef_environment}")
hadoop_namenode = hadoop_namenode.length == 1 ? hadoop_namenode.first[:fqdn] : "localhost"

hadoop_backupnamenode = search(:node, "role:hadoop_backupnamenode AND chef_environment:#{node.chef_environment}")
hadoop_backupnamenode = hadoop_backupnamenode.length == 1 ? hadoop_backupnamenode.first[:fqdn] : "localhost"

hadoop_jobtracker = search(:node, "role:hadoop_jobtracker AND chef_environment:#{node.chef_environment}")
hadoop_jobtracker = hadoop_jobtracker.length == 1 ? hadoop_jobtracker.first[:fqdn] : "localhost"

hadoop_datanodes = Array.new
search(:node, "role:hadoop_datanode AND chef_environment:#{node.chef_environment}").each do |n|
  hadoop_datanodes << n[:fqdn]
end

# setup hadoop group
group "hadoop" do
end

# setup hadoop user
user "hadoop" do
  comment "Hadoop user"
  gid "hadoop"
  home "/home/hadoop"
  shell "/bin/bash"
  supports :manage_home => true
end

cookbook_file "/home/hadoop/.bashrc" do
  source "bashrc"
  owner "hadoop"
  group "hadoop"
  mode 00644
end

# setup ssh
remote_directory "/home/hadoop/.ssh" do
  source "ssh"
  owner "hadoop"
  group "hadoop"
  files_owner "hadoop"
  files_group "hadoop"
  files_mode 00600
  mode 00700
end

# create the install dir
directory node[:hadoop][:install_stage_dir] do
  owner "hadoop"
  group "hadoop"
  mode 00744
  recursive true
end

# install the hadoop rpm from our repo
package "hadoop" do
  action :install
  version "1.0.3-1"
end

# manage hadoop configs
%w[core-site.xml log4j.properties fair-scheduler.xml hadoop-env.sh hadoop-policy.xml hdfs-site.xml mapred-site.xml masters slaves taskcontroller.cfg].each do |template_file|
  template "/etc/hadoop/#{template_file}" do
    source "hadoop-conf/#{template_file}"
    mode 00755
    variables(
      :namenode => hadoop_namenode,
      :jobtracker => hadoop_jobtracker,
      :backupnamenode => hadoop_backupnamenode,
      :datanodes => hadoop_datanodes
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
file "/etc/security/limits.d/123hadoop.conf" do
  owner "root"
  group "root"
  mode 00644
  content "hadoop  -       nofile  32768"
  action :create
end