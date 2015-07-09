#
# Cookbook Name:: rundeck
# Recipe:i: node_windows
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



if node['rundeck']['secret_file'].nil?
  rundeck_secure = data_bag_item(node['rundeck']['rundeck_databag'], node['rundeck']['rundeck_databag_secure'])
else
  rundeck_secret = Chef::EncryptedDataBagItem.load_secret(node['rundeck']['secret_file'])
  rundeck_secure = Chef::EncryptedDataBagItem.load(node['rundeck']['rundeck_databag'], node['rundeck']['rundeck_databag_secure'], rundeck_secret)
end

user node['rundeck']['windows']['user'] do
  system true
  comment 'Rundeck User for access over winrm'
  password rundeck_secure['windows_password']
  not_if { rundeck_secure['windows_password'].nil? }
  notifies :manage, "group[#{node['rundeck']['windows']['group']}]"
end

group node['rundeck']['windows']['group'] do
  append true
  members node['rundeck']['windows']['user']
end
