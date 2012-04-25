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

%w[python-simplejson python-cjson"].each do |pkg|
  package pkg do
    action :install
  end
end

hadoop_namenode = search(:node, "role:hadoop_namenode AND chef_environment:#{node.chef_environment}")
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
  mode "0644"
end

# setup ssh
remote_directory "/home/hadoop/.ssh" do
  source "ssh"
  owner "hadoop"
  group "hadoop"
  files_owner "hadoop"
  files_group "hadoop"
  files_mode "0600"
  mode "0700"
end

# create the install dir
directory "#{node[:hadoop][:install_stage_dir]}" do
  owner "hadoop"
  group "hadoop"
  mode 00744
  recursive true
end

# download rpm
remote_file "#{node[:hadoop][:install_stage_dir]}/hadoop-#{node[:hadoop][:version]}.amd64.rpm" do
  source "http://mirror.uoregon.edu/apache/hadoop/common/hadoop-#{node[:hadoop][:version]}/hadoop-#{node[:hadoop][:version]}-1.amd64.rpm"
  owner "hadoop"
  group "hadoop"
  mode "0744"
  not_if "test -f #{node[:hadoop][:install_stage_dir]}/hadoop-#{node[:hadoop][:version]}.amd64.rpm"
end

# install rpm
package "hadoop-#{node[:hadoop][:version]}-1.amd64" do
  action :install
  source "#{node[:hadoop][:install_stage_dir]}/hadoop-#{node[:hadoop][:version]}.amd64.rpm"
  provider Chef::Provider::Package::Rpm
end

# manage hadoop configs
%w[core-site.xml fair-scheduler.xml hadoop-env.sh hadoop-policy.xml hdfs-site.xml mapred-site.xml masters slaves taskcontroller.cfg].each do |template_file|
  template "/etc/hadoop/#{template_file}" do
    source "hadoop-conf/#{template_file}"
    mode "0755"
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
  execute "fix perms on #{file_name}" do
    command "chmod 0555 /usr/sbin/#{file_name}"
  end
end

# increase the file limits for the hadoop user
file "/etc/security/limits.d/123hadoop.conf" do
  owner "root"
  group "root"
  mode "0644"
  content "hadoop  -       nofile  32768"
  action :create
end
