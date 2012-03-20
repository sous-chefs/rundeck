#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: squid
# Recipe:: default
#
# Copyright 2012, Opscode, Inc
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

package "squid"

service "squid" do
  supports :restart => true, :status => true, :reload => true
  provider Chef::Provider::Service::Upstart
  action [ :enable, :start ]
end

if node['squid']['network']
  network = node['squid']['network']
else
  network = node.ipaddress[0,node.ipaddress.rindex(".")]+".0/24"
end
Chef::Log.info "Squid network #{network}"

template "/etc/squid/squid.conf" do
  source "squid.conf.erb"
  notifies :reload, "service[squid]"
end

template "/etc/squid/chef.acl.config" do
  source "chef.acl.config.erb"
  variables(
    :network => network
    )
  notifies :reload, "service[squid]"
end
