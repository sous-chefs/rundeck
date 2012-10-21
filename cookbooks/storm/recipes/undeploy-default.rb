#
# Cookbook Name:: storm
# Recipe:: undeploy
#
# Copyright 2012, Webtrends, Inc.
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

install_dir  = "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}"

# clean out the install directory from the previous version
directory "#{install_dir}" do
  recursive true
  action :delete
end

# clean out the local state from the previous version
directory "#{node['storm']['local_dir']}/supervisor" do
  recursive true
  action :delete
end