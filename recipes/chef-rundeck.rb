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
include_recipe 'rundeck::_data_bags'
include_recipe 'rundeck::chef_server_config'

projects = {}
node.run_state['rundeck']['projects'].each do |project_name, data_bag_item_contents|
  projects[project_name] = {
    'pattern' => data_bag_item_contents['pattern'],
    'username' => data_bag_item_contents['username'],
    'hostname' => data_bag_item_contents['hostname'],
    'attributes' => data_bag_item_contents['attributes'],
  }
end

directory node['rundeck']['chef_configdir'] do
  # owner node[:user][:username]
  # group node[:user][:username]
  recursive true
end

file node['rundeck']['project_config'] do
  content JSON.pretty_generate(projects)
  mode '0644'
  notifies :restart, 'service[chef-rundeck]'
end

chef_gem 'chef-rundeck' do
  source node['rundeck']['chef_rundeck_gem']
  action :upgrade
  not_if { node['rundeck']['chef_rundeck_gem'].nil? }
end

chef_gem 'chef-rundeck' do
  action :upgrade
  only_if { node['rundeck']['chef_rundeck_gem'].nil? }
end

chef_gem 'sinatra'

directory node['rundeck']['log_dir'] do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  mode '0755'
end

file "#{node['rundeck']['log_dir']}/server.log" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  action :create_if_missing
end

template '/etc/systemd/system/chef-rundeck.service' do
  source 'chef-rundeck-systemd.conf.erb'
  variables(
    user: node['rundeck']['user'],
    log_dir: node['rundeck']['log_dir'],
    chef_config: node['rundeck']['chef_config'],
    chef_webui_url: node['rundeck']['chef_webui_url'],
    project_config: node['rundeck']['project_config'],
    chef_rundeck_host: node['rundeck']['chef_rundeck_host'],
    chef_rundeck_port: node['rundeck']['chef_rundeck_port'],
    chef_rundeck_cachetime: node['rundeck']['chef_rundeck_cachetime'],
    chef_rundeck_partial_search: node['rundeck']['chef_rundeck_partial_search']
  )
  only_if { node['rundeck']['chef_rundeck_use_systemd'] }
  notifies :restart, 'service[chef-rundeck]'
end

template '/etc/init/chef-rundeck.conf' do
  source 'chef-rundeck.conf.erb'
  variables(
    user: node['rundeck']['user'],
    log_dir: node['rundeck']['log_dir'],
    chef_config: node['rundeck']['chef_config'],
    chef_webui_url: node['rundeck']['chef_webui_url'],
    project_config: node['rundeck']['project_config'],
    chef_rundeck_host: node['rundeck']['chef_rundeck_host'],
    chef_rundeck_port: node['rundeck']['chef_rundeck_port'],
    chef_rundeck_cachetime: node['rundeck']['chef_rundeck_cachetime'],
    chef_rundeck_partial_search: node['rundeck']['chef_rundeck_partial_search']
  )
  only_if { node['rundeck']['chef_rundeck_use_upstart'] }
  notifies :restart, 'service[chef-rundeck]'
end

if node['rundeck']['chef_rundeck_use_runit']
  # Use runit, compatibility for non-Upstart systems and backwards-compatibility
  # for previous versions of this cookbook
  include_recipe 'runit::default'
  runit_service 'chef-rundeck' do
    options(
      user: node['rundeck']['user'],
      log_dir: node['rundeck']['log_dir'],
      chef_config: node['rundeck']['chef_config'],
      chef_webui_url: node['rundeck']['chef_webui_url'],
      project_config: node['rundeck']['project_config'],
      chef_rundeck_host: node['rundeck']['chef_rundeck_host'],
      chef_rundeck_port: node['rundeck']['chef_rundeck_port'],
      chef_rundeck_cachetime: node['rundeck']['chef_rundeck_cachetime'],
      chef_rundeck_partial_search: node['rundeck']['chef_rundeck_partial_search']
    )
    notifies :restart, 'service[chef-rundeck]'
  end
end

service 'chef-rundeck' do
  if node['rundeck']['chef_rundeck_use_systemd']
    provider Chef::Provider::Service::Systemd
  end
  if node['rundeck']['chef_rundeck_use_upstart']
    provider Chef::Provider::Service::Upstart
  end
  action [:start]
end
