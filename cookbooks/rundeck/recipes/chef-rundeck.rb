#
# Cookbook Name:: rundeck
# Recipe:: chef-rundeck
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
include_recipe 'runit'

bags = data_bag('rundeck')

projects = {}
bags.each do |project|
  pdata = data_bag_item('rundeck', project)
  projects[project] = {
    'pattern' => pdata['pattern'],
    'username' => pdata['username'],
    'hostname' => pdata['hostname']
  }
end

file node['rundeck']['project_config'] do
  content JSON.pretty_generate(projects)
  mode 00644
  notifies :restart, 'service[chef-rundeck]'
end

cookbook_file '/tmp/chef-rundeck-0.2.1.gem' do
  source 'chef-rundeck-0.2.1.gem'
  mode 00644
  notifies :install, 'chef_gem[chef-rundeck]'
end

chef_gem 'chef-rundeck' do
  source '/tmp/chef-rundeck-0.2.1.gem'
  action :nothing
end

chef_gem 'sinatra'

link '/usr/bin/chef-rundeck' do
  to File.join(::Gem.bindir, 'chef-rundeck')
  only_if do node[:platform_version] >= '10.04' end
end

template '/etc/chef/rundeck.rb' do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  source 'rundeck.rb.erb'
  variables(
    :rundeck => node['rundeck']
  )
end

runit_service 'chef-rundeck' do
  options(
    :user => node['rundeck']['user'],
    :chef_config => node['rundeck']['chef_config'],
    :chef_webui_url => node['rundeck']['chef_webui_url'],
    :project_config => node['rundeck']['project_config']
  )
  notifies :restart, 'service[chef-rundeck]'
end

service 'chef-rundeck' do
  action :start
end
