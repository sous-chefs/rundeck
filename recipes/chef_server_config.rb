#
# Cookbook Name:: rundeck
# Recipe:i: chef_server_config
#
# Copyright 2016, Snehit Gajjar
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

include_recipe 'rundeck::_data_bags'

template '/etc/chef/rundeck.rb' do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  source 'rundeck.rb.erb'
  variables(
    rundeck: node['rundeck']
  )
end

file '/etc/chef/rundeck.pem' do
  content node.run_state['rundeck']['data_bag']['secure']['chef_rundeck_pem']
  owner node['rundeck']['user']
  group node['rundeck']['group']
  mode '0400'
end
