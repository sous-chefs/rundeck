#
# Cookbook Name::	kafka
# Description::     Base configuration for Kafka
# Recipe::			default
#
# Copyright 2012, Webtrends, Inc.
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

# == Recipes
include_recipe "java"
include_recipe "runit"

java_home   = node['java']['java_home']
user = "kafka"
group = "kafka"

if node[:kafka][:broker_id].nil? || node[:kafka][:broker_id].empty?
    node[:kafka][:broker_id] = node[:ipaddress].gsub(".","")
end

if node[:kafka][:broker_host_name].nil? || node[:kafka][:broker_host_name].empty?
    node[:kafka][:broker_host_name] = node[:fqdn]
end

log "Broker id: #{node[:kafka][:broker_id]}"
log "Broker name: #{node[:kafka][:broker_host_name]}"

# == Users

# setup kafka group
group group do
end

# setup kafka user
user user do
  comment "Kafka user"
  gid "kafka"
  home "/home/kafka"
  shell "/bin/noshell"
  supports :manage_home => false
end

# create the install directory
install_dir = node[:kafka][:install_dir]

directory "#{install_dir}" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

# create the log directory
directory "#{node[:kafka][:log_dir]}" do
  owner   user
  group   group
  mode    00755
  recursive true
  action :create
end

# create the data directory
directory "#{node[:kafka][:data_dir]}" do
  owner   user
  group   group
  mode    00755
  recursive true
  action :create
end

# pull the remote file only if we create the directory
tarball = "kafka-#{node[:kafka][:version]}.tar.gz"
download_file = "#{node[:kafka][:download_url]}/#{tarball}"

remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
    source download_file
    mode 00644
    action :create_if_missing
end

execute "tar" do
  user  "root"
  group "root" 
  creates "#{node[:kafka][:installDir]}/bin"
  cwd install_dir
  command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
end

template "#{install_dir}/bin/service-control" do
  source  "service-control.erb"
  owner "root"
  group "root"
  mode  00755
  variables({
        :install_dir => install_dir,
		:log_dir => node[:kafka][:log_dir], 
        :java_home => java_home,
        :java_jmx_port => 9999,
        :java_class => "kafka.Kafka",
        :user => user
  })
end

# grab the zookeeper nodes that are currently available
zookeeper_pairs = Array.new
if not Chef::Config.solo
    search(:node, "role:zookeeper AND chef_environment:#{node.chef_environment}").each do |n|
		zookeeper_pairs << n[:fqdn]
	end
end

# append the zookeeper client port (defaults to 2181)
i = 0
while i < zookeeper_pairs.size do
  zookeeper_pairs[i] = zookeeper_pairs[i].concat(":#{node[:zookeeper][:clientPort]}")
  i += 1
end

%w[server.properties consumer.properties producer.properties zookeeper.properties log4j.properties].each do |template_file|
  template "#{install_dir}/config/#{template_file}" do
        source	"#{template_file}.erb"
        owner user
        group group
        mode  00755
        variables({ 
            :kafka => node[:kafka],
            :zookeeper_pairs => zookeeper_pairs,
            :client_port => node[:zookeeper][:clientPort]
        })
    end
end

# delete the application tarball
execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
end

# create the runit service
runit_service "kafka" do
    options({
        :log_dir => node[:kafka][:log_dir],
        :install_dir => install_dir,
        :java_home => java_home,
        :user => user
      }) 
end
