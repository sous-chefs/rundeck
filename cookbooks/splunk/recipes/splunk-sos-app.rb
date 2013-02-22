#
# Cookbook Name:: splunk
# Recipe:: splunk-sos-app
#
# Copyright 2011-2012, BBY Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Required App for SoS

splunk_app_install "Installing #{node['splunk']['sideview_file']} -- Version: #{node['splunk']['sideview_version']}" do
  action                  [:create_if_missing]
  app_file                node['splunk']['sideview_file']
  app_version             node['splunk']['sideview_version']
  remove_dir_on_upgrade   "true"
end

# SoS

splunk_app_install "Installing #{node['splunk']['splunk_sos_file']} -- Version: #{node['splunk']['splunk_sos_version']}" do
  action                  [:create_if_missing]
  app_file                node['splunk']['splunk_sos_file']
  app_version             node['splunk']['splunk_sos_version']
  remove_dir_on_upgrade   "true"
end
