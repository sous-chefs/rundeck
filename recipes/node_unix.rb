#
# Cookbook Name:: rundeck
# Recipe:i: node_unix
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

include_recipe 'rundeck::_data_bags'

group node['rundeck']['group'] do
  system true
end

user node['rundeck']['user'] do
  comment 'Rundeck User'
  home node['rundeck']['user_home']
  gid node['rundeck']['group']
  system true
  shell '/bin/bash'
end

directory node['rundeck']['user_home'] do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  recursive true
  mode '0700'
end

directory "#{node['rundeck']['user_home']}/.ssh" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  recursive true
  mode '0700'
end

file "#{node['rundeck']['user_home']}/.ssh/authorized_keys" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  mode '0600'
  backup false
  content node.run_state['rundeck']['data_bag']['secure']['public_key']
end

sudo 'rundeck-admin' do
  user node['rundeck']['user']
  nopasswd true
end
