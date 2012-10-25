#
# Cookbook Name:: shark
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

include_recipe "spark"

install_dir = "#{node['shark']['install_dir']}/shark-#{node['shark']['version']}"
hive_path = "#{node['shark']['install_dir']}/hive-#{node['shark']['hive']['version']}-bin"
hadoop_path = "#{node['shark']['install_dir']}/hadoop-#{node['shark']['hadoop']['version']}"
spark_master = search(:node, "role:spark_master AND chef_environment:#{node.chef_environment}").first


# setup directories
directory node['shark']['install_dir'] do
  owner "spark"
  group "spark"
  action :create
  recursive true
end

# download Shark
remote_file "#{Chef::Config[:file_cache_path]}/shark-#{node[:shark][:version]}-bin.tgz" do
  source "#{node['shark']['download_url']}/shark-#{node['shark']['version']}-bin.tgz"
  owner  "spark"
  group  "spark"
  mode   00744
  not_if "test -f #{Chef::Config[:file_cache_path]}/shark-#{node['shark']['version']}-bin.tgz"
end

# uncompress the application tarball into the install directory
execute "tar" do
  user    "spark"
  group   "spark"
  creates "#{node['shark']['install_dir']}/shark-#{node['shark']['version']}"
  cwd     "#{node['shark']['install_dir']}"
  command "tar -zxvf #{Chef::Config[:file_cache_path]}/shark-#{node['shark']['version']}-bin.tgz"
end

# create a link from the specific version to a generic current folder
link "#{node['shark']['install_dir']}/current" do
	to "#{node['shark']['install_dir']}/shark-#{node['shark']['version']}"
end






# download hadoop
remote_file "#{Chef::Config[:file_cache_path]}/hadoop-#{node[:shark][:hadoop][:version]}-bin.tar.gz" do
  source "#{node['shark']['hadoop']['download_url']}/hadoop-#{node[:shark][:hadoop][:version]}/hadoop-#{node['shark']['hadoop']['version']}-bin.tar.gz"
  owner  "spark"
  group  "spark"
  mode   00744
  not_if "test -f #{Chef::Config[:file_cache_path]}/hadoop-#{node[:shark][:hadoop][:version]}-bin.tar.gz"
end

# uncompress the application tarball into the install directory
execute "tar" do
  user    "spark"
  group   "spark"
  creates "#{node['shark']['install_dir']}/hadoop-#{node['shark']['hadoop']['version']}"
  cwd     "#{node['shark']['install_dir']}"
  command "tar -zxvf #{Chef::Config[:file_cache_path]}/hadoop-#{node[:shark][:hadoop][:version]}-bin.tar.gz"
end




# non-executable templates
%w{log4j.properties}.each do |name|
  template "#{install_dir}/conf/#{name}" do
    source "#{name}"
    mode 00644
  end
end

# executable templates
%w{shark-env.sh}.each do |name|
  template "#{install_dir}/conf/#{name}" do
    source "#{name}"
    mode 00755
    variables(
      :hive_path => hive_path,
      :hadoop_path => hadoop_path,
      :spark_home => install_dir,
      :master_ip => spark_master[:ipaddress]
    )
  end
end


