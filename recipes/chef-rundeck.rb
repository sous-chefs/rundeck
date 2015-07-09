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

if node['rundeck']['secret_file'].nil?
  rundeck_secure = data_bag_item(node['rundeck']['rundeck_databag'], node['rundeck']['rundeck_databag_secure'])
else
  rundeck_secret = Chef::EncryptedDataBagItem.load_secret(node['rundeck']['secret_file'])
  rundeck_secure = Chef::EncryptedDataBagItem.load(node['rundeck']['rundeck_databag'], node['rundeck']['rundeck_databag_secure'], rundeck_secret)
end

bags = data_bag(node['rundeck']['rundeck_projects_databag'])
projects = {}
bags.each do |project|
  pdata = data_bag_item(node['rundeck']['rundeck_projects_databag'], project)
  projects[project] = {
    'pattern' => pdata['pattern'],
    'username' => pdata['username'],
    'hostname' => pdata['hostname'],
    'attributes' => pdata['attributes']
  }
end

directory node['rundeck']['chef_configdir'] do
  #owner node[:user][:username]
  #group node[:user][:username]
  recursive true
end

file node['rundeck']['project_config'] do
  content JSON.pretty_generate(projects)
  mode 00644
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

template '/etc/chef/rundeck.rb' do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  source 'rundeck.rb.erb'
  variables(
    rundeck: node['rundeck']
  )
end

file '/etc/chef/rundeck.pem' do
  content rundeck_secure['chef_rundeck_pem']
  owner node['rundeck']['user']
  group node['rundeck']['group']
  mode 0400
end

directory node['rundeck']['log_dir'] do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  mode 00755
end

file "#{node['rundeck']['log_dir']}/server.log" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  action :create_if_missing
end

if node['rundeck']['chef_rundeck_use_upstart']
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
    notifies :restart, 'service[chef-rundeck]'
  end
else
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
  provider Chef::Provider::Service::Upstart if node['rundeck']['chef_rundeck_use_upstart']
  action :start
end
