#
# Author:: Guilhem Lettron (<guilhem.lettron@youscribe.com>)
# Cookbook Name:: webpi
# Recipe:: install-msi
#
# Copyright 2011, Opscode, Inc.
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

include_recipe "windows"

#msi bug workaround
msi_file = ::File.join( Chef::Config[:file_cache_path], "wpi.msi" )

remote_file "msi" do
  path msi_file
  source node['webpi']['msi']
  action :create
end

windows_package "Web Platform Installer" do
  source msi_file
  action :install
end

# MSI manage PATH
node.default['webpi']['bin'] = "WebpiCmd.exe"
