#
# Cookbook Name:: spark
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


install_dir = "#{node['spark']['install_dir']}/spark-#{node['spark']['version']}"

# setup spark group
group "spark"

# setup spark user
user "spark" do
	comment "Spark user"
	gid "spark"
	home "/home/spark"
	shell "/bin/bash"
	supports :manage_home => true
end

# setup ssh keys so we can use the easy cluster start/stop scripts
remote_directory "/home/spark/.ssh" do
	source "ssh"
	owner "spark"
	group "spark"
	files_owner "spark"
	files_group "spark"
	files_mode 00600
	mode 00700
end

# setup directories
directory node['spark']['install_dir'] do
  owner "spark"
  group "spark"
  action :create
  recursive true
end

# download spark
remote_file "#{Chef::Config[:file_cache_path]}/spark-#{node[:spark][:version]}-prebuilt.tar.gz" do
  source "#{node['spark']['download_url']}/spark-#{node['spark']['version']}-prebuilt.tar.gz"
  owner  "spark"
  group  "spark"
  mode   00744
  not_if "test -f #{Chef::Config[:file_cache_path]}/spark-#{node['spark']['version']}-prebuilt.tar.gz"
end

# uncompress the application tarball into the install directory
execute "tar" do
  user    "spark"
  group   "spark"
  creates "#{node['spark']['install_dir']}/spark-#{node['spark']['version']}"
  cwd     "#{node['spark']['install_dir']}"
  command "tar -zxvf #{Chef::Config[:file_cache_path]}/spark-#{node['spark']['version']}-prebuilt.tar.gz"
end

# create a link from the specific version to a generic current folder
link "#{node['spark']['install_dir']}/current" do
	to "#{node['spark']['install_dir']}/spark-#{node['spark']['version']}"
end

