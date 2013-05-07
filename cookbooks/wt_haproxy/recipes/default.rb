#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

include_recipe "wt_haproxy::install_#{node['haproxy']['install_method']}"

search_query = ""
proxy_hash = Hash.new
proxy_roles = Array.new
role_list = ["wt_actioncenter_management_api", "wt_v360"] ##<----This will be a cookbook attribute we use to build an array of groups of nodes we want to proxy

role_list.each do |r|
  proxy_roles << Chef::Role.load(r)   ##<--Loads role objects from the array
end


##whitelist and blacklist will let us control what environments we want to search for nodes in. In prod we'll want to blacklist preprod etc.
whitelist = ["H-LAS"]
blacklist = 


## This builds a string that gets used for searching based on whitelist/blacklist settings
if whitelist
  search_query << " AND ("
  whitelist.each_with_index do |env, index|
    if index < (whitelist.size - 1)
      search_query << "chef_environment:#{env} OR "
    else
      search_query << "chef_environment:#{env}"
    end
  end
  search_query << ")"
elsif blacklist
  search_query = " AND NOT ("
  blacklist.each_with_index do |env, index|
	 if index < (blacklist.size - 1)
	   search_query << "chef_environment:#{env} OR "
	 else
	   search_query << "chef_environment:#{env}"
	 end
	end
	search_query << ")"
end

## Here's where we actually find the nodes we want
proxy_roles.each do |p|
  node_a = search(:node, "role:#{p.name}#{search_query}") ##Here we are searching for all the nodes that fit our criteria. 
  proxy_hash[p] = node_a
end


cookbook_file "/etc/default/haproxy" do
  source "haproxy-default"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[haproxy]"
end

template "#{node['haproxy']['conf_dir']}/haproxy.cfg" do
  source "haproxy.cfg.erb"
  owner "root"
  group "root"
  mode 00644
  variables(
	:defaults_timeouts=>node['haproxy']['defaults_timeouts'],
	:defaults_options=>node['haproxy']['defaults_options'],
	:proxy_inf=>proxy_hash
  )
  notifies :reload, "service[haproxy]"
end

service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
