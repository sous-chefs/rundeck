#
# Cookbook Name:: kafka
# Attributes:: default
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

# zookeeper 
default[:kafka][:zookeeper_recipe] = "zookeeper"
default[:kafka][:zookeeper_client_port] = 2181

# Install
default[:kafka][:version]           = "0.7.0"

case platform
when "centos","redhat","fedora"
	set[:kafka][:user] = 'kafka'
	set[:kafka][:group] = 'nogroup'
	set[:kafka][:home_dir] = "/usr/share/kafka"
	set[:kafka][:data_dir] = "/usr/share/kafka/kafka-logs"
	set[:kafka][:stage_dir] = "/usr/local/share/kafka"
	set[:kafka][:log_dir] = "/var/log/kafka"
when "debian","ubuntu"
	set[:kafka][:user] = 'kafka'
	set[:kafka][:group] = 'nogroup'
	set[:kafka][:home_dir] = "/usr/share/kafka"
	set[:kafka][:data_dir] = "/usr/share/kafka/kafka-logs"
	set[:kafka][:stage_dir] = "/usr/local/share/kafka"
	set[:kafka][:log_dir] = "/var/log/kafka"
else
	set[:kafka][:user] = 'kafka'
	set[:kafka][:group] = 'nogroup'
	set[:kafka][:home_dir] = "/usr/share/kafka"
	set[:kafka][:data_dir] = "/usr/share/kafka/kafka-logs"
	set[:kafka][:stage_dir] = "/usr/local/share/kafka"
	set[:kafka][:log_dir] = "/var/log/kafka"
end

# Directories, hosts and ports        # =
default[:users]['kafka'][:uid]      = 350
default[:users]['kafka'][:gid]      = 350


