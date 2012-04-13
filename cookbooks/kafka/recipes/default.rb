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

# == Users

# Setup kafka user
user "#{node[:kafka][:user]}" do
  comment "Kafka user"
  gid "#{node[:kafka][:group]}"
  home "/home/#{node[:kafka][:user]}"
  shell "/bin/bash"
  supports :manage_home => true
end

# == Directories
home_dir = node[:kafka][:home_dir]

# Create a staging home for Kafka
directory "#{node[:kafka][:stage_dir]}" do
	mode "0755"
	action :create
	owner "root"
	group "root"
	not_if { ::File.exists?("#{node[:kafka][:stage_dir]}") }
end

# Download Kafka to the staging directory. For now the tar is embedded with the cookbook.
cookbook_file "/usr/local/src/kafka-#{node[:kafka][:version]}.tar.gz" do
  source 	"kafka-#{node[:kafka][:version]}.tar.gz"
  owner 	"#{node[:kafka][:user]}"
  group 	"#{node[:kafka][:group]}"
  mode 		"0744"
  not_if 	"test -f /usr/local/src/kafka-#{node[:kafka][:version]}.tar.gz"
end

# Extract it
execute 	"extract-kafka" do
  command	"tar -zxf /usr/local/src/kafka-#{node[:kafka][:version]}.tar.gz"
  creates	"kafka-#{node[:kafka][:version]}"
  cwd 		"#{node[:kafka][:stage_dir]}"
  user		"root"
  group 	"root"
end

# link the extracted bits
link home_dir do
	to          "#{node[:kafka][:stage_dir]}"
	action    	:create
	link_type 	:symbolic
	owner 		"#{node[:kafka][:user]}"
	group 		"#{node[:kafka][:group]}"
	not_if { ::File.exists?("#{home_dir}") }
end

# The directories to manage
kafka_dirs = [
	node['kafka']['data_dir'],
	node['kafka']['stage_dir'],
	node['kafka']['log_dir']
]

# Create all other directories, if needed
kafka_dirs.each do |dir|
        directory dir do
        mode        "0744"
        action      :create
        owner       "#{node[:kafka][:user]}"
        group       "#{node[:kafka][:group]}"
        recursive   true
    end
end

# grab the zookeeper nodes that are currently available
zookeeper_pairs = Array.new
if not Chef::Config.solo
    search(:node, "recipe:#{node[:kafka][:zookeeper_recipe]} AND chef_environment:#{node.chef_environment}").each do |n|
		zookeeper_pairs << n[:fqdn]
	end
end

# append the zookeeper client port (defaults to 2181)
i = 0
while i < zookeeper_pairs.size do
  zookeeper_pairs[i] = zookeeper_pairs[i].concat(":#{node[:kafka][:zookeeper_client_port]}")
  i += 1
end

# templates
%w[kafka-server-start.sh kafka-run-class.sh sv-kafka-run sv-kafka-log-run].each do |template_file|
  template "#{home_dir}/bin/#{template_file}" do
	source	"#{template_file}.erb"
	mode 		"0755"
	variables({
		:kafka => node[:kafka]
	})
	end
end

%w[server.properties consumer.properties producer.properties zookeeper.properties log4j.properties].each do |template_file|
  template "#{home_dir}/config/#{template_file}" do
        source	"#{template_file}.erb"
        mode 		"0755"
        owner		"root"
        variables({ 
            :kafka => node[:kafka],
            :zookeeper_pairs => zookeeper_pairs
        })
    end
end

runit_service "kafka"
