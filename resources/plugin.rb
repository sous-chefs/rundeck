#
# Cookbook Name:: rundeck
# Resource:: plugin
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

include RundeckCookbook::Helpers

property :name, String,
         name_property: true # 'Name of the plugin to install'
property :url, String,
         required: true # 'URL to the plugin to install.'
property :checksum, String # 'The SHA-256 checksum of the plugin.'
property :basedir, String,
         default: '/var/lib/rundeck' # 'Location to Rundecks base installation directory.'
property :rundeckgroup, String,
         default: 'rundeck' # 'The user account that rundeck will operate as'
property :rundeckuser, String,
         default: 'rundeck' # 'The group that rundeck will operate as'
property :restart_on_config_change, [true, false],
         default: false # 'Whether to restart rundeck service when a configuration has changed.'

action :create do
  remote_file "#{new_resource.basedir}/libext/#{new_resource.name}" do
    source new_resource.url
    checksum new_resource.checksum
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    mode '0644'
    backup false
    action :create
    notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
  end

  service 'rundeckd' do
    action :nothing
  end
end

action_class do
  include Apache2::Cookbook::Helpers
end
