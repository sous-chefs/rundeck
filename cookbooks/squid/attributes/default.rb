#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: squid
# Attributes:: default
#
# Copyright 2012 Opscode, Inc
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

default['squid']['port'] = 3128
default['squid']['network'] = nil
default['squid']['config_file'] = "/etc/squid/squid.conf"
default['squid']['timeout'] = "10"
default['squid']['opts'] = ""
default['squid']['version'] = ""

if node['platform_family'] = "debian" and node['platform_version'].to_f >= 11.10
    default['squid']['service_name'] = "squid3"
else
	default['squid']['service_name'] = "squid"
end