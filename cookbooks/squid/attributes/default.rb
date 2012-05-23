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

default[:squid][:port] = 3128
default[:squid][:network] = nil

# network segments to allow connections from (default is the default from the squid config)
default[:squid][:localnet] = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]

# ssl ports to allow outbound connects to (default is the default from the squid config)
default[:squid][:ssl_ports] = ["443","563","873"]

# ports to allow outbound connections to (default is the default from the squid config)
default[:squid][:safe_ports] = ["80","21","443","70","210","1025-65535","280","488","591","777","631","873","901"]
