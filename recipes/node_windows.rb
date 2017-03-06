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

include_recipe 'rundeck::_data_bags'

user node['rundeck']['windows']['user'] do
  system true
  comment 'Rundeck User for access over winrm'
  password node.run_state['rundeck']['data_bag']['secure']['windows_password']
  not_if { node.run_state['rundeck']['data_bag']['secure']['windows_password'].nil? }
  notifies :manage, "group[#{node['rundeck']['windows']['group']}]"
end

group node['rundeck']['windows']['group'] do
  append true
  members node['rundeck']['windows']['user']
end
