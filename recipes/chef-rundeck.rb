#
# Cookbook Name:: rundeck
# Recipe:i: chef-rundeck
#
# Copyright 2012, Peter Crossley
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

require 'json'

include_recipe 'rundeck::default'

rundeck_secure = data_bag_item('rundeck', 'secure')

if !node['rundeck']['secret_file'].nil? then
  rundeck_secret = Chef::EncryptedDataBagItem.load_secret(node['rundeck']['secret_file'])
  rundeck_secure = Chef::EncryptedDataBagItem.load('rundeck', 'secure', rundeck_secret)
end  


bags = data_bag('rundeck_projects')
projects = {}
bags.each do |project|
  pdata = data_bag_item('rundeck_projects', project)
  projects[project] = {
    "pattern" => pdata['pattern'],
    "username" => pdata['username'],
    "hostname" => pdata['hostname']
  }
end

file node['rundeck']['project_config'] do
  content JSON.pretty_generate(projects)
  mode 00644
  notifies :restart, "service[chef-rundeck]"
end

gem_package "chef-rundeck" do
  source node['rundeck']['chef_rundeck_gem']
  action :upgrade
  not_if do node['rundeck']['chef_rundeck_gem'].nil? end
end

gem_package "chef-rundeck" do
  action :upgrade
  only_if do node['rundeck']['chef_rundeck_gem'].nil? end
end

gem_package "sinatra"

template "/etc/chef/rundeck.rb" do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  source "rundeck.rb.erb"
  variables(
    :rundeck => node['rundeck']
  )
end

file "/etc/chef/rundeck.pem" do
  content rundeck_secure['chef_rundeck_pem']
  owner node['rundeck']['user']
  group node['rundeck']['user']
  mode 0400
end

runit_service "chef-rundeck" do
  options(
    :user => node['rundeck']['user'],
    :chef_config => node['rundeck']['chef_config'],
    :chef_webui_url => node['rundeck']['chef_webui_url'],
    :project_config => node['rundeck']['project_config'],
    :chef_rundeck_host => node['rundeck']['chef_rundeck_host'],
    :chef_rundeck_port => node['rundeck']['chef_rundeck_port'],
    :chef_rundeck_partial_search => node['rundeck']['chef_rundeck_partial_search']
  )
  notifies :restart, "service[chef-rundeck]"
end

service "chef-rundeck" do
  action :start
end
