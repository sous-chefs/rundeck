#
# Cookbook Name:: rundeck
# Recipe::server
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

node.run_state['rundeck'] = Hash.recursive

ruby_block "connect rundeck api client" do
  action :nothing
  block do
    unless node.run_state['rundeck']['api_client']
      admin_user = node['rundeck']['admin_user']
      node.run_state['rundeck_api_client'] = RundeckApiClient.connect(
        File.join(node['rundeck']['grails_server_url'], node['rundeck']['webcontext']),
        admin_user,
        node.run_state['rundeck']['data_bag']['users']['users'][admin_user]['password']
      )
    end
  end
end

include_recipe 'rundeck::_data_bags'
include_recipe 'rundeck::server_dependencies'
include_recipe 'rundeck::apache'
include_recipe 'rundeck::server_install'
